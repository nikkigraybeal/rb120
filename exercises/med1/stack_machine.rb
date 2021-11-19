=begin
You may remember our Minilang language from back in the RB101-RB109 Medium exercises. We return to that language now, but this time we'll be using OOP. If you need a refresher, refer back to that exercise.

Write a class that implements a miniature stack-and-register-based programming language that has the following commands:

n Place a value n in the "register". Do not modify the stack.
PUSH Push the register value on to the stack. Leave the value in the register.
ADD Pops a value from the stack and adds it to the register value, storing the result in the register.
SUB Pops a value from the stack and subtracts it from the register value, storing the result in the register.
MULT Pops a value from the stack and multiplies it by the register value, storing the result in the register.
DIV Pops a value from the stack and divides it into the register value, storing the integer result in the register.
MOD Pops a value from the stack and divides it into the register value, storing the integer remainder of the division in the register.
POP Remove the topmost item from the stack and place in register
PRINT Print the register value
All operations are integer operations (which is only important with DIV and MOD).

Programs will be supplied to your language method via a string passed in as an argument. Your program should produce an error if an unexpected item is present in the string, or if a required stack value is not on the stack when it should be (the stack is empty). In all error cases, no further processing should be performed on the program.

You should initialize the register to 0.

Minilang has a 
  Stack has a 
    Register

Minilang takes a string
  parses string into method calls that use Stack and Register values
    integer updates Register value
    PUSH add Reg val to Stack
    ADD remove val from Stack, add to and update Reg val
    SUB remove val from Stack, sub from and update Reg val
    MULT remove val from Stack, mult by Reg val and update
    DIV
    MOD
    POP remove val from Stack and place in Reg
    PRINT Reg val

Stack is an array

Regisgter is a value

=end

class MinilangError < StandardError; end
class BadTokenError < MinilangError; end
class EmptyStackError < MinilangError; end

class Minilang
  COMMANDS = %w(PRINT POP PUSH MULT ADD SUB DIV MOD)
  attr_accessor :string, :commands, :stack, :register

  def initialize(string)
    @string = string
    @commands = parse_string
    @stack = []
    @register = Register.new
  end

  def PRINT
    puts register.value
  end

  def PUSH
    stack.push(register.value)
  end
    
  def POP
    raise EmptyStackError, "Empty stack!" if stack.empty?
  end

  def MULT
    n = stack.pop
    register.value *= n
  end

  def ADD
    n = stack.pop
    register.value += n
  end

  def SUB
    n = stack.pop
    register.value -= n
  end

  def DIV
    n = stack.pop
    register.value /= n
  end

  def MOD
    n = stack.pop
    register.value %= n
  end

  def parse_string
    methods = string.split.map do |command|
      if command == command.to_i.to_s
        command.to_i
      else command
      end
    end
    methods
  end

  def eval
    commands.each {|command| eval_command(command)}
    rescue MinilangError => error
      puts error.message
  end

  def eval_command(command)
      if command.class == Integer
        register.value = command
      elsif COMMANDS.include?(command)
        send(command)
      else
        raise BadTokenError, "Invalid token: #{command}"
      end
  end
end

class Register
  attr_accessor :value
  def initialize
    @value = 0
  end
end



Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15


Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

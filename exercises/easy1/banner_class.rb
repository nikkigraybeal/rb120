class Banner
  def initialize(message, width=message.size+2)
    @message = message
    @width = width
    @width = message.size if @width < @message.size || @width > 118
  end


  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+" + ("-" * (@width)) + "+"
  end

  def empty_line
    "|" + (" " * (@width)) + "|"
  end

  def message_line
    if @width.even?
      spaces = @width - @message.size
      "|#{" "*(spaces/2)}#{@message}#{" "*(spaces/2)}|"
    else 
      spaces = @width - @message.size
      "|" + (" " * ((spaces/2)+1)) + @message + (" " * (spaces/2)) + "|"
    end
  end
end

=begin
Complete this class so that the test cases shown below work as intended. You are free to add any methods or instance variables you need. However, do not make the implementation details public.

You may assume that the input will always fit in your terminal window.

problem: given a message, output it to the screen inside of a banner consisting of the message enclosed in dashes with plus signs in the corners.
input: string
output: new string consisting of old string in a box

rules: empty inputs return an empty box
       horizontal_rule begins and ends with "+" and has "-" in between
       empty_line begins and ends with "|"
       message_line begins and ends with "|" with message in between
       all lines are the same length: length of message + 4 including bookends

algorithm:
  create a method called horizontal_rule
    "+" + ("-" * (message.size + 2)) + "+"

  create a method called empty_line
    "|" + (" " * (message.size + 2)) + "|"

  create a method called message_line
    "|" + " " + message + " " + "|"



Test Cases
=end
banner = Banner.new('To boldly go where no one has gone before.', 117)
puts banner
=begin
+--------------------------------------------+
|                                            |
| To boldly go where no one has gone before. |
|                                            |
+--------------------------------------------+
Copy Code
=end
banner = Banner.new('', 15)
puts banner
=begin
+--+
|  |
|  |
|  |
+--+
=end
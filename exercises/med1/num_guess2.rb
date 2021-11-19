=begin
Update your solution to accept a low and high value when you create a GuessingGame object, and use those values to compute a secret number for the game. You should also change the number of guesses allowed so the user can always win if she uses a good strategy. You can compute the number of guesses with:

Math.log2(size_of_range).to_i + 1
E
xamples:

game = GuessingGame.new(501, 1500)
game.play

You have 10 guesses remaining.
Enter a number between 501 and 1500: 104
Invalid guess. Enter a number between 501 and 1500: 1000
Your guess is too low.

...

game.play
You have 10 guesses remaining.
Enter a number between 501 and 1500: 1000
Your guess is too high.

...

You have no more guesses. You lost!
=end
class GuessingGame
  attr_accessor :player, :computer, :secret_number, :guesses, :range, :min, :max

  def initialize(min, max)
    @min = min
    @max = max
    @range = (min..max)
    @player = Player.new(range)
    @computer = Computer.new(range)
    @secret_number = computer.secret_number
    @guesses = Math.log2(range.to_a.size).to_i + 1
  end

  def play
    loop do
      guess_number
      break if player.guess == secret_number || guesses == 0 
    end
    results
    reset
  end

  private
  def guess_number
    if guesses == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{guesses} guesses remaining."
    end
    computer.feedback(player.guess_number)
    self.guesses -= 1
  end

  def results
    if secret_number == player.guess
      puts "You won!"
    else
      puts "You have no more guesses. You lost!"
    end
  end

  def reset
    self.computer = Computer.new(range)
    self.secret_number = computer.secret_number
    self.guesses = Math.log2(range.to_a.size).to_i + 1
  end
end

class Computer
  attr_reader :secret_number, :range

  def initialize(range)
    @range = range
    @secret_number = range.to_a.sample
  end

  def feedback(player_guess)
    if player_guess > secret_number
      puts "Your guess is too high."
    elsif player_guess < secret_number
      puts "Your guess is too low."
    else puts "That's the number!"
    end
  end
end

class Player
  attr_accessor :guess, :range

  def initialize(range)
    @range = range.to_a
    @guess = nil
  end

  def guess_number
    answer = nil
    puts "Enter a number between #{range.min} and #{range.max}:"
    loop do
      answer = gets.chomp.to_i
      break if (range).include?(answer)
      puts "Invalid guess. Enter a number between 1 and 100:" if answer < 1 || answer > 100
    end
    self.guess = answer
    answer
  end
end

game = GuessingGame.new(1, 5)
game.play

game.play
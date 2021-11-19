=begin
Create an object-oriented number guessing class for numbers in the range 1 to 100, with a limit of 7 guesses per game. The game should play like this:

game = GuessingGame.new
game.play

You have 7 guesses remaining.
Enter a number between 1 and 100: 104
Invalid guess. Enter a number between 1 and 100: 50
Your guess is too low.

You have 6 guesses remaining.
Enter a number between 1 and 100: 75
Your guess is too low.

You have 5 guesses remaining.
Enter a number between 1 and 100: 85
Your guess is too high.

You have 4 guesses remaining.
Enter a number between 1 and 100: 0
Invalid guess. Enter a number between 1 and 100: 80

You have 3 guesses remaining.
Enter a number between 1 and 100: 81
That's the number!

You won!

game.play

You have 7 guesses remaining.
Enter a number between 1 and 100: 50
Your guess is too high.

You have 6 guesses remaining.
Enter a number between 1 and 100: 25
Your guess is too low.

You have 5 guesses remaining.
Enter a number between 1 and 100: 37
Your guess is too high.

You have 4 guesses remaining.
Enter a number between 1 and 100: 31
Your guess is too low.

You have 3 guesses remaining.
Enter a number between 1 and 100: 34
Your guess is too high.

You have 2 guesses remaining.
Enter a number between 1 and 100: 32
Your guess is too low.

You have 1 guesses remaining.
Enter a number between 1 and 100: 32
Your guess is too low.

You have no more guesses. You lost!

Descripton: Computer chooses a secret number between 1 - 100. Player has 7 attempts to guess the number. Computer gives feedback about the accuracy of Player's guess (too high or too low). Player wins if they guess the secret number in 7 or less attempts. Otherwise, player loses.

Nouns:
  Computer
  Player
  Secret Number
  Attempts
  Feedback

Verbs:
  choose secret number
  guess
  give feedbck
  player wins
  player looses
=end

class GuessingGame
  attr_accessor :player, :computer, :secret_number, :guesses

  def initialize
    @player = Player.new
    @computer = Computer.new
    @secret_number = computer.secret_number
    @guesses = 7
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
    self.computer = Computer.new
    self.secret_number = computer.secret_number
    self.guesses = 7
  end
end

class Computer
  attr_reader :secret_number

  def initialize
    @secret_number = (1..100).to_a.sample
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
  attr_accessor :guess

  def initialize
    @guess = nil
  end

  def guess_number
    answer = nil
    puts "Enter a number between 1 and 100:"
    loop do
      answer = gets.chomp.to_i
      break if (1..100).to_a.include?(answer)
      puts "Invalid guess. Enter a number between 1 and 100:" if answer < 1 || answer > 100
    end
    self.guess = answer
    answer
  end
end

game = GuessingGame.new
game.play

game.play


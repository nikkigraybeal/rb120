=begin
textual description: Rock, Paper, Scissors is a two-player
game where each player chooses one of three possible moves:
rock, paper, or scissors. The chosen moves will then be
compared to see who wins, according to the following rules:

- rock beats scissors
- scissors beats paper
- paper beats rock

If the players chose the same move, then it's a tie.

Nouns: player, move, rule
Verbs: choose, compare

Player
 - choose
Move
Rule

- compare
=end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']

  def to_s
    self.name
  end
end

class Rock < Move
  attr_reader :name
  def initialize
    @name = 'rock'
  end
  
  def >(other_move)
    other_move == Scissors || other_move == Lizard
  end 

  def <(other_move)
    other_move == Paper || other_move == Spock
  end
end

class Paper < Move
  attr_reader :name
  def initialize
    @name = 'paper'
  end
  
  def >(other_move)
    other_move == Rock || other_move == Spock
  end 

  def <(other_move)
    other_move == Scissors || other_move == Lizard
  end
end

class Scissors < Move
  attr_reader :name
  def initialize
    @name = 'scissors'
  end
  
  def >(other_move)
    other_move == Paper || other_move == Lizard
  end 

  def <(other_move)
    other_move == Rock || other_move == Spock
  end
end

class Spock < Move
  attr_reader :name
  def initialize
    @name = 'spock'
  end
  
  def >(other_move)
    other_move == Rock || other_move == Scissors
  end 

  def <(other_move)
    other_move == Paper || other_move == Lizard
  end
end

class Lizard < Move
  attr_reader :name
  def initialize
    @name = 'lizard'
  end
  
  def >(other_move)
    other_move == Spock || other_move == Paper
  end 

  def <(other_move)
    other_move == Scissors || other_move == Rock
  end
end

class Player
  attr_accessor :rock, :paper, :scissors, :spock, :lizard, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def determine_move(choice)
    case choice
    when 'rock'
      Rock.new
    when 'paper'
      Paper.new
    when 'scissors'
      Scissors.new
    when 'spock'
      Spock.new
    when 'lizard'
      Lizard.new
    end
  end

end

class Human < Player
  def set_name
    puts "Enter your name:"
    self.name = gets.chomp
    self.name = 'Player' if name.empty?
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, spock or lizard."
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "That's not a valid entry."
    end
    determine_move(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Chappie', 'Number 5', 'Hal'].sample
  end

  def choose
    determine_move(Move::VALUES.sample)
  end
end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, #{human.name}!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, #{human.name}. Goodbye!"
  end

  def display_moves(human_move, computer_move)
    puts "\n#{human.name} chose #{human_move}."
    puts "#{computer.name} chose #{computer_move}.\n\n"
  end

  def display_winner(human_move, computer_move)
    if human_move > computer_move.class
      puts "You won, #{human.name}!"
    elsif human_move < computer_move.class
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def increment_score(human_move, computer_move)
    if human_move > computer_move.class
      human.score += 1
    elsif human_move < computer_move.class
      computer.score += 1
    end
  end

  def display_score(human_move, computer_move)
    increment_score(human_move, computer_move)
    puts "\n#{human.name}'s score: #{human.score}"
    puts  "#{computer.name} score: #{computer.score}\n"
  end

  def match?
    human.score == 10 || computer.score == 10
  end

  def display_match_winner
    if human.score == 10
      puts "#{human.name} won the match!"
    else 
      puts "#{computer.name} won the Match!"
    end
  end

  def play_again?
    choice = nil
    loop do
      puts "Would you like to play again? y/n"
      choice = gets.chomp
      break if ['y', 'n'].include?(choice)
      puts "Please enter y or n."
    end
    return false if choice == 'n'
    return true if choice == 'y'
  end

  def reset_game
    human.score = 0
    computer.score = 0
  end

  def play
    display_welcome_message
    loop do
      reset_game
      loop do
        human_move = human.choose
        computer_move = computer.choose
        display_moves(human_move, computer_move)
        display_winner(human_move, computer_move)
        display_score(human_move, computer_move)
        break if match?
      end
      display_match_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play

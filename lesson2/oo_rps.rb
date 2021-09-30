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

  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def spock?
    @value == 'spock'
  end

  def lizard?
    @value == 'lizard'
  end

  def >(other_move)
    (rock? && (other_move.scissors? || other_move.lizard?)) ||
      (paper? && (other_move.rock? || other_move.spock?)) ||
      (scissors? && (other_move.paper? || other_move.lizard?)) ||
      (spock? && (other_move.scissors? || other_move.rock?)) ||
      (lizard? && (other_move.spock? || other_move.paper?))
  end

  def <(other_move)
    (rock? && (other_move.paper? || other_move.spock?)) ||
      (paper? && (other_move.scissors? || other_move.lizard?)) ||
      (scissors? && (other_move.rock? || other_move.spock?)) ||
      (spock? && (other_move.paper? || other_move.lizard?)) ||
      (lizard? && (other_move.rock? || other_move.scissors?))
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
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
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def initialize
    super
    @moves = create_moves_array(name)
  end

  def set_name
    self.name = ['R2D2', 'Chappie', 'Number 5', 'Hal'].sample
  end

  def create_moves_array(computer_name)
    moves = []
    if computer_name == 'R2D2'
      moves = ['rock']
    elsif computer_name == 'Hal'
      moves = ['scissors', 'scissors', 'scissors', 'scissors', 'scissors', 'rock', 'lizard', 'spock']
    elsif computer_name == 'Chappie'
      moves = ['spock', 'lizard', 'paper']
    elsif computer_name == 'Number 5'
      moves = ['spock', 'spock', 'spock', 'rock', 'paper', 'scissors', 'lizard']
    end
    moves
  end

  def choose
    self.move = Move.new(@moves.sample)
  end
end

class History
  attr_accessor :history
  
  def initialize
    @history = []
  end

  def add_move(player)
    history << player.move
  end

  def to_s
    history.each do |obj|
      obj.value
    end
  end

  def display
    puts history
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

  def display_moves
    puts "\n#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}.\n\n"
  end

  def display_winner
    if human.move > computer.move
      puts "You won, #{human.name}!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def increment_score
    if human.move > computer.move
      human.score += 1
    elsif human.move < computer.move
      computer.score += 1
    end
  end

  def display_score
    increment_score
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
      human_history = History.new
      computer_history = History.new
      loop do
        human.choose
        computer.choose
        human_history.add_move(human)
        computer_history.add_move(computer)
        display_moves
        display_winner
        display_score
        break if match?
      end
      display_match_winner
      puts "Human moves: #{human_history.display}"
      puts "Computer moves: #{computer_history.display}"
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play

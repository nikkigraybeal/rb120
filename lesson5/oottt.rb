=begin
Problem: Tic Tac Toe is a two-player game in which each player
puts a game piece on a grid-board and tries to fill a row
(horizontal vertical or diagonal) with thier pieces.
Nouns: player, board, game-piece, row
Verbs: place piece

Tic Tac Toe is a 2-player board game played on a 3x3 grid.
Players take turns marking a square. The first player to mark
3 squares in a row wins.
Nouns: player, board, turn, square, row
Verbs: play, mark

Possible Classes and Methods:
Board
Square
Player
 -mark
 -play

 Spike:
=end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  attr_accessor :squares

  def initialize
    @squares = create_board
  end

  def create_board
    board = {}
    (1..9).each { |num| board[num] = Square.new }
    board
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts "-----------------"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts "-----------------"
    puts "     |     |"
    puts "   #{squares[7]} |   #{squares[8]} |  #{squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # returns square number
  def squares_with(marker)
    squares.select { |_, square_obj| square_obj.status == marker }.keys
  end

  def joinor(arr, delimiter = ", ", last_joiner = "or ")
    arr.insert(-2, last_joiner)
    last = arr.delete_at(-1)
    arr.join(delimiter) + last.to_s
  end

  # change marker for any square with board[square num] = status/marker
  def []=(num, status)
    squares[num].status = status
  end

  def someone_won?
    win = false
    WINNING_LINES.each do |line|
      if line.intersection(squares_with('X')).size == 3 ||
         line.intersection(squares_with('O')).size == 3
        win = true
      end
    end
    win
  end

  def full?
    squares_with(' ').empty?
  end
end

class Square
  attr_accessor :status

  def initialize(status=' ')
    @status = status
  end

  def to_s
    @status
  end
end

class Player
  attr_accessor :name, :marker, :current_player, :score

  def initialize(name, marker, current_player = nil)
    @name = name
    @marker = marker
    @current_player = current_player
    @score = 0
  end
end

class TTTGame
  COMPUTER_NAMES = ['R2D2', 'Hal', 'Number 5',
                    'Joshua', 'JARVIS', 'Colossus']

  attr_reader :human, :computer
  attr_accessor :board

  def initialize
    display_welcome_message
    @human = Player.new(human_name, choose_marker, play_first?)
    @computer = Player.new(computer_name, computer_marker)
    @board = Board.new
  end

  def play
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  def match_play
    loop do
      display_board
      player_moves
      display_results
      tally_win
      break if someone_won_match?
      reset_board
    end
  end

  def main_game
    loop do
      match_play
      display_match_results
      break unless play_again?
      reset_game
    end
  end

  def clear_screen
    system 'clear'
  end

  def display_welcome_message
    clear_screen
    puts "Welcome to Tic Tac Toe!"
  end

  def display_goodbye_message
    clear_screen
    puts "Thank you for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You are #{human.marker} Computer is #{computer.marker}"
    puts ""
    board.draw
    puts ""
    display_score
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end

  def human_name
    name = nil
    loop do
      puts "Please enter your name:"
      name = gets.chomp
      break unless name.empty? || COMPUTER_NAMES.include?(name)
      puts "That's not a valid entry."
    end
    clear_screen
    name
  end

  def choose_marker
    marker = nil
    loop do
      puts "Would you like to be Xs or Os?"
      marker = gets.chomp.upcase
      break if marker == 'X' || marker == 'O'
      puts "That's not a valid entry. Enter 'X' or 'O'."
    end
    clear_screen
    marker
  end

  def human_chooses_who_goes_first?
    answer = nil
    puts "Would you like to choose who goes first? y/n"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Please answer y or n"
    end
    answer == 'y'
  end

  def human_chooses_self?
    answer = nil
    puts "Would you like to go first? y/n"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Please answer y or n"
    end
    clear_screen
    answer == 'y'
  end

  def play_first?
    if human_chooses_who_goes_first?
      human_chooses_self?
    else
      clear_screen
      [true, false].sample
    end
  end

  def computer_name
    COMPUTER_NAMES.sample
  end

  def computer_marker
    human.marker == 'X' ? 'O' : 'X'
  end

  def board_empty?
    board.squares_with(' ').size == 9
  end

  def possible_win
    square = nil
    Board::WINNING_LINES.each do |line|
      marked = line.intersection(board.squares_with(computer.marker))
      unmarked = line - marked
      square = unmarked[0] if unmarked.size == 1 &&
                              board.squares[unmarked[0]].status == ' '
    end
    square
  end

  def at_risk
    square = nil
    Board::WINNING_LINES.each do |line|
      marked = line.intersection(board.squares_with(human.marker))
      unmarked = line - marked
      square = unmarked[0] if unmarked.size == 1 &&
                              board.squares[unmarked[0]].status == ' '
    end
    square
  end

  def find_best_move
    return possible_win if !possible_win.nil?
    return at_risk if !at_risk.nil?
    return 5 if board.squares[5].status == ' '
    board.squares_with(' ').sample
  end

  def pick_square(square_number)
    board[square_number] = computer.marker
  end

  def computer_moves
    square = find_best_move
    pick_square(square)
  end

  def human_moves
    player_choice = nil
    loop do
      puts "Choose a square: #{board.joinor(board.squares_with(' '))}"
      player_choice = gets.chomp.to_i
      break if board.squares_with(' ').include?(player_choice)
      puts "That's not a valid entry"
    end
    board[player_choice] = human.marker
  end

  def current_player_moves
    if human.current_player == true
      human_moves
      human.current_player = false
    else
      computer_moves
      human.current_player = true
    end
  end

  def player_moves
    loop do
      current_player_moves
      clear_screen_and_display_board
      break if board.someone_won? || board.full?
    end
  end

  def winning_marker
    Board::WINNING_LINES.each do |line|
      return 'X' if line.intersection(board.squares_with('X')).size == 3
      return 'O' if line.intersection(board.squares_with('O')).size == 3
    end
    nil
  end

  def x_player
    human.marker == 'X' ? human.name : computer.name
  end

  def o_player
    human.marker == 'O' ? human.name : computer.name
  end

  def display_results
    case winning_marker
    when nil
      puts "It's a tie!"
    when 'X'
      puts "#{x_player} wins!"
    when 'O'
      puts "#{o_player} wins!"
    end
  end

  def someone_won_match?
    human.score == 5 || computer.score == 5
  end

  def play_again?
    answer = nil
    puts "Would you like to play again?"
    loop do
      answer = gets.chomp.downcase
      break if %w(y yes n no).include?(answer)
      puts "Please enter y or n"
    end
    %w(y yes).include?(answer)
  end

  def tally_win
    human.score += 1 if winning_marker == human.marker
    computer.score += 1 if winning_marker == computer.marker
    loop do
      puts "press return to continue"
      gets.chomp
      break
    end
  end

  def display_score
    puts "SCORE"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def display_match_results
    clear_screen_and_display_board
    if human.score > computer.score
      puts "You won the match!"
    else puts "#{computer.name} won the match!"
    end
  end

  def set_winner_to_play_first
    return nil if winning_marker.nil?
    human.current_player = false
    human.current_player = true if winning_marker == human.marker
  end

  def reset_board
    clear_screen
    set_winner_to_play_first
    self.board = Board.new
  end

  def reset_game
    clear_screen
    puts "Let's play again!"
    human.marker = choose_marker
    computer.marker = computer_marker
    human.current_player = play_first?
    human.score = 0
    computer.score = 0
    self.board = Board.new
  end
end

game = TTTGame.new
game.play

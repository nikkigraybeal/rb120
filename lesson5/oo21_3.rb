=begin
Twenty-One Game Description: Twenty-One is a card game.
There are a player and a dealer. Cards are worth their nominal
value, face cards are worth 10 and Aces can be worth either 11 or 1.
The dealer shuffles then deals 2 cards to each player, including
themselves from a standard 52 card deck. The player can see both of
their cards but only one of the dealer's cards. Player turn: player
hits or stays trying to get as close to 21 as possible without going
over. If the Player goes over 21, they bust and the dealer wins. Dealer
turn: Dealer hits until cards total at least 17. If dealer busts, player
wins. Whoever has the highest score wins.

Twenty_one
  has player
    has name
        hand
          has cards[]
              value
  dealer
    has name
        hand
          has cards[]
              value
  deck
    has cards[]
      has name
          value))

  start
    welcome
    loop do                                                                 
      deal
      player_turn
      dealer_turn
      show_results
      break unless play_again?
    end
    goodbye
  end

Deck
  has cards[]
      has name
          value
  shuffle

Card
  has name
      value

Hand
  has value
      cards[]
        has name
            value

Participant
  has name
      hand
        has cards
            value

Player is a Participant

Dealer is a Participant
=end

module Displayable
  def clear_screen
    system 'clear'
  end

  def cards
    hand.cards.map(&:name)
  end

  def show_cards
    clear_screen
    puts "#{player.name}'s cards: #{player.cards.join(', ')}"
    puts "#{dealer.name}'s cards: #{dealer.cards[0]}, (second card hidden)"
  end

  def show_flop
    clear_screen
    puts "#{player.name}'s cards: #{player.cards.join(', ')}"
    puts "#{dealer.name}'s cards: #{dealer.cards.join(', ')}"
  end

  def show_score
    puts "#{name}'s score: #{hand.value}"
  end

  def results(other)
    if hand.value > 21
      puts "#{name} busts! #{other.name} wins!"
    elsif hand.value > other.hand.value
      puts "#{name} wins!"
    end
  end

  def show_results
    player.show_score
    dealer.show_score
    show_push
    player.results(dealer)
    dealer.results(player)
  end

  private
  def welcome
    clear_screen
    puts "Welcome to Twenty-One! Please enter your name:"
    player.name = gets.chomp
    puts "Hi, #{player.name}! Press enter to deal cards."
    gets.chomp
  end

  def show_push
    puts "Push!" if player.hand.value == dealer.hand.value
  end

  def goodbye
    puts "Thanks for playing Twenty-One, #{player.name}!"
  end
end

class TwentyOne
  include Displayable
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    welcome
    loop do
      deal
      take_turns
      show_results
      break unless play_again?
      reset
    end
    goodbye
  end

  private
  def deal
    2.times do
      player.hand.cards << deck.deal_card
      dealer.hand.cards << deck.deal_card
    end
    update_scores_and_show_cards
  end

  def update_scores
    [player, dealer].each { |participant| participant.hand.update_value }
  end

  def update_scores_and_show_cards
    update_scores
    show_cards
  end

  def player_turn
    loop do
      update_scores_and_show_cards
      break if dealer.hand.win? || player.turn_ends?
      player.hand.cards << deck.deal_card
    end
  end

  def dealer_turn
    loop do
      break if dealer.turn_ends?
      dealer.hand.cards << deck.deal_card
      update_scores
    end
  end

  def take_turns
    loop do
      player_turn
      break if player.hand.busted? || player.hand.win?
      dealer_turn
      break if dealer.turn_ends?
    end
    show_flop
  end

  def play_again?
    answer = nil
    puts "Would you like to play again? y/n"
    loop do
      answer = gets.chomp.downcase
      break if %w(y yes n no).include?(answer)
      puts "Please enter y(es) or n(o)."
    end
    %w(y yes).include?(answer)
  end

  def reset
    self.deck = Deck.new
    player.hand = Hand.new
    dealer.hand = Hand.new
  end
end

class Card
  attr_accessor :name, :value

  def initialize(name)
    @name = name
    @value = card_value
  end

  private
  def card_value
    if name[0] == "A"
      11
    elsif name[0].to_i < 2
      10
    else
      name[0].to_i
    end
  end
end

class Deck
  SUITS = ["Hearts", "Diamonds", "Spades", "Clubs"]
  CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]
  attr_accessor :cards

  def initialize
    @cards = create_deck
    shuffle
  end

  def deal_card
    cards.shift
  end

  private
  def create_deck
    deck = []
    SUITS.each do |suit|
      CARDS.each do |card|
        deck << Card.new("#{card} of #{suit}")
      end
    end
    deck
  end

  def shuffle
    cards.shuffle!
  end
end

class Hand
  attr_accessor :cards, :value

  def initialize
    @cards = []
    @value = nil
  end

  def update_value
    self.value = cards.map(&:value).reduce(:+)
  end

  def win?
    calculate_aces
    value == 21
  end

  def busted?
    calculate_aces
    value > 21
  end

  private
  def calculate_aces
    aces = cards.select { |card| card.value == 11 }
    loop do
      break if value <= 21 || aces.empty?
      aces[0].value = 1
      aces.shift
    end
    update_value
  end
end

class Participant
  include Displayable
  attr_accessor :name, :hand

  def initialize
    @name = nil
    @hand = Hand.new
  end

  def turn_ends?
    hand.win? || hand.busted? || stay?
  end
end

class Player < Participant
  def stay?
    stay = false
    puts "Would you like to hit or stay? h/s"
    loop do
      answer = gets.chomp.downcase
      stay = true if %w(s stay).include?(answer)
      break if %w(h hit s stay).include?(answer)
      "Please enter h(it) or s(tay)."
    end
    stay
  end
end

class Dealer < Participant
  COMPUTER_NAMES = ['R2D2', 'Hal', 'Number 5',
                    'Joshua', 'JARVIS', 'Colossus']
  def initialize
    super
    self.name = COMPUTER_NAMES.sample
  end

  def stay?
    hand.value >= 17
  end
end

game = TwentyOne.new
game.start

=begin
Twenty-One Game Description: Twenty-One is a card game.
There is a player and a dealer. Cards are worth their nominal
value, face cards are worth 10 and Aces can be worth either 11 or 1.
The dealer shuffles then deals 2 cards to each player, including
themselves from a standard 52 card deck. The player can see both of
their cards but only one of the dealers cards. Player turn: player
hits or stays trying to get as close to 21 as possible without going
over. If the Player goes over 21, they bust and the dealer wins. Dealer
turn: Dealer hits until cards total at least 17. If dealer busts, player
wins. Whoever has the highest score wins.

Nouns/verbs:
Game
 start
Deck
  create_deck => [card objects]
  shuffle
Card(s)
  name
  value
Player
  hand
  busted?
  blackjack?
Dealer
  hand
  busted?
  blackjack?
  deal

module Hand
  hit
  stay
  total
  win?

=end
require 'pry'

module Displayable
  def clear_screen
    system 'clear'
  end

  def welcome_message
    clear_screen
    puts "Welcome to Twenty-One! Please enter your name:"
    answer = gets.chomp
    puts "Hi, #{answer}! Press enter to deal cards."
    gets.chomp
    player.name = answer
  end

  def show_cards
    puts "#{name}'s cards: #{hand.card_names}"
    puts ""
  end

  def show_one_card
    puts "#{name}'s cards: #{hand.card_names.split(',')[0]}, (second card hidden)"
  end

  def detect_win(other)
    puts ""
    if hand.busted?
      puts "#{name} busts! #{other.name} wins!"
    elsif hand > other.hand
      puts "#{name} wins!"
    end
  end

  def detect_tie
    puts "Push!" if player.hand.calculate_total == dealer.hand.calculate_total
  end

  def show_results
    puts ""
    puts "#{show_cards}"
    puts ""
    puts "#{name}'s total: #{hand.calculate_total}"
    puts ""
  end

  def play_again?
    answer = nil
    puts ""
    puts "Would you like to play again? y/n"
    loop do
      answer = gets.chomp.downcase
      break if %w(n no y yes).include?(answer)
      "Please enter y (yes) or n (no)."
    end
    %w(y yes).include?(answer)
  end

  def goodbye_message
    clear_screen
    puts "Thanks for playing Twenty-One, #{player.name}! Goodbye!"
  end
end

class Oo21
  include Displayable
  attr_accessor :deck, :discards, :player, :dealer

  def initialize
    @deck = Deck.new
    @deck.cards.shuffle!
    @discards = []
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    welcome_message
    loop do
      deal_initial_cards
      player.show_cards
      dealer.show_one_card
      if player.hand.win? || dealer.hand.win?
        player.detect_win(dealer)
        dealer.detect_win(player)
        detect_tie
        play_again? ? reset : break
      end
      [player, dealer].each { |participant| participant.take_turn(deck) }
      player.detect_win(dealer)
      dealer.detect_win(player)
      detect_tie
      play_again? ? reset : break
    end
    goodbye_message
  end

  def deal_initial_cards
    2.times do
      player.hand.hand << deck.deal_card
      dealer.hand.hand << deck.deal_card
    end
  end


  def shuffle_shoe
    deck.cards += discards
    self.discards = []
    deck.cards.shuffle!
  end

  def reset
    clear_screen
    self.discards += player.hand.hand + dealer.hand.hand
    if deck.cards.size <= 26
      shuffle_shoe
    end
    player.hand = Hand.new
    dealer.hand = Hand.new
  end
end

class Deck
  SUITS = ["Hearts", "Diamonds", "Spades", "Clubs"]
  CARDS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]
  attr_accessor :cards

  def initialize
    @cards = create_deck
  end

  def create_deck
    deck = []
    SUITS.each do |suit|
      CARDS.each do |card|
        deck << Card.new("#{card} of #{suit}")
      end
    end
    deck
  end

  def deal_card
    cards.shift
  end
end

class Card
  attr_accessor :name, :value

  def initialize(name)
    @name = name
    @value = card_value
  end

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

class Hand
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def card_names
    hand.map(&:name).join(", ")
  end

  def win?
    calculate_total == 21
  end

  def busted?
    calculate_total > 21
  end

  def stay?
    calculate_total >= 17
  end

  def calculate_aces
    aces = hand.select { |card| card.value == 11 }
    loop do
      break if total <= 21 || aces.empty?
      aces[0].value = 1
      aces.shift
    end
  end

  def total
    hand.map(&:value).reduce(:+)
  end

  def calculate_total
    calculate_aces
    total
  end

  def >(other)
    calculate_total > other.calculate_total
  end
end

class Participant
  attr_accessor :hand

  def initialize
    @hand = Hand.new
  end
end

class Player < Participant
  include Displayable
  attr_accessor :name

  def initialize
    super()
    @name = nil
  end

  def take_turn(deck)
    loop do
      break if turn_ends?
      break if %w(s stay).include?(hit_or_stay(deck))
      clear_screen
      show_cards
    end
    clear_screen
    show_results
  end

  def hit_or_stay(deck)
    answer = nil
    puts ""
    puts "Would you like to hit or stay? h/s"
    loop do
      answer = gets.chomp.downcase
      break if %w(h s hit stay).include?(answer)
      puts "Please enter h (hit) or s (stay)"
    end
    puts "#{name}'s cards: #{hand.card_names}"
    hand.hand << deck.deal_card if %w(h hit).include?(answer)
    answer
  end

  def turn_ends?
    hand.busted? || hand.win?
  end
end

class Dealer < Participant
  COMPUTER_NAMES = ['R2D2', 'Hal', 'Number 5',
                    'Joshua', 'JARVIS', 'Colossus']
  include Displayable                    
  attr_accessor :name

  def initialize
    super()
    @name = COMPUTER_NAMES.sample
  end

  def take_turn(deck)
    loop do
      break if turn_ends?
      hand.hand << deck.deal_card
    end
    clear_screen
    show_results
  end

  def turn_ends?
    hand.busted? || hand.win? || hand.stay?
  end
end

game = Oo21.new
game.start

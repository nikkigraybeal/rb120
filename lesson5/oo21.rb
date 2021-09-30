=begin
Twenty-One Game Description: Twenty-One is a card game. There is a player and a dealer. Cards are worth their nominal value, face cards are worth 10 and Aces can be worth either 11 or 1. The dealer shuffles then deals 2 cards to each player, including themselves from a standard 52 card deck. The player can see both of their cards but only one of the dealers cards. Player turn: player hits or stays trying to get as close to 21 as possible without going over. If the Player goes over 21, they bust and the dealer wins. Dealer turn: Dealer hits until cards total at least 17. If dealer busts, player wins. Whoever has the highest score wins. Ties are called push.

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

class Game
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @deck.cards.shuffle!
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    deal_cards
    show_initial_cards
    player_turn
    #dealer_turn
    show_results
  end

  def deal_cards
    2.times do 
      player.hand << deck.deal_card
      dealer.hand << deck.deal_card
    end
  end

  def show_initial_cards
    puts "player cards: #{player.get_card_names}"
    puts "dealer cards: #{dealer.get_card_names.split(",")[0]}, (second card hidden)"
  end

  def hit_or_stay
    answer = nil
    puts "Would you like to hit or stay? h/s"
    loop do
      answer = gets.chomp.downcase
      break if %w(h s hit s stay).include?(answer)
      puts "Please enter h (hit) or s (stay)"
    end
    player.hit if %w(h hit).include?(answer)
  end

  def player_turn
    loop do
      hit_or_stay
      show_initial_cards
      break if player.busted? || player.stays
    end
  end

  def show_results
    puts "player cards: #{player.get_card_names}"
    puts "player total: #{player.calculate_total}"
    puts "dealer cards: #{dealer.get_card_names}"
    puts "dealer total: #{dealer.calculate_total}"
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
        if card.class == Integer
          value = card
        elsif card == "Ace"
          value = 11
        else value = 10
        end
        deck << Card.new("#{card} of #{suit}", value)
      end
    end
    deck
  end

  def deal_card
    cards.shift
  end
end

class Card
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end
end

module Hand
  def get_card_names
    hand.map{|card| card.name}.join(", ")
  end

  def win?
    calculate_total == 21
  end

  def busted?
    calculate_total > 21
  end

  def hit
    hand << deck.deal_card
  end
  
  def stay
  end

  def calculate_aces
    aces = hand.select{|card| card.value == 11}
    loop do
      break if raw_total <= 21 || aces.empty?
      aces[0].value = 1
      aces.shift
      end
      binding.pry
  end

  def raw_total
    hand.map{|card| card.value}.reduce(:+)
  end

  def calculate_total
    calculate_aces
    raw_total
  end
end

class Player
  include Hand
  attr_accessor :hand, :busted, :blackjack

  def initialize
    @hand = []
    @busted = busted?
    @blackjack = blackjack?
  end

  def busted?
  end

  def blackjack?
  end
end

class Dealer
  include Hand
  attr_accessor :hand, :busted, :blackjack

  def initialize
    @hand = []
    @busted = busted?
    @blackjack = blackjack?
  end

  def busted?
  end

  def blackjack?
  end
end




game = Game.new
game.start





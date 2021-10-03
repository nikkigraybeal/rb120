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

class Game
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
      loop do
        break if blackjack?
        player_turn
        break if player_turn_ends?
        dealer_turn
        break if dealer_turn_ends?
      end
      show_results
      play_again? ? reset : break
    end
    goodbye_message
  end

  def clear_screen
    system 'clear'
  end

  def welcome_message
    clear_screen
    puts "Welcome to Twenty-One! Press return to deal cards."
    gets.chomp
  end

  def deal_initial_cards
    2.times do
      player.hand << deck.deal_card
      dealer.hand << deck.deal_card
    end
    show_cards
  end

  def show_cards
    clear_screen
    puts "player cards: #{player.card_names}"
    puts "dealer cards: #{dealer.card_names.split(',')[0]}, (second card hidden)"
  end

  def blackjack?
    dealer.win? || player.win?
  end

  def hit_or_stay
    answer = nil
    puts ""
    puts "Would you like to hit or stay? h/s"
    loop do
      answer = gets.chomp.downcase
      break if %w(h s hit stay).include?(answer)
      puts "Please enter h (hit) or s (stay)"
    end
    player.hand << deck.deal_card if %w(h hit).include?(answer)
    answer
  end

  def player_turn
    loop do
      break if player.busted? || player.win?
      break if %w(s stay).include?(hit_or_stay)
      show_cards
    end
  end

  def player_turn_ends?
    player.busted? || player.win?
  end

  def show_dealer_cards
    clear_screen
    puts "player cards: #{player.card_names}"
    puts "dealer cards: #{dealer.card_names}"
  end

  def dealer_turn
    loop do
      show_dealer_cards
      break if dealer.busted? || dealer.win? || dealer.stay?
      dealer.hand << deck.deal_card
    end
  end

  def dealer_turn_ends?
    dealer.busted? || dealer.win? || dealer.stay?
  end

  def declare_winner
    if player.busted?
      puts "Player busts, Dealer wins!"
    elsif dealer.busted?
      puts "Dealer busts, Player wins!"
    elsif player > dealer
      puts "Player wins!"
    elsif dealer > player
      puts "Dealer wins!"
    else puts "Push!"
    end
  end

  def show_results
    clear_screen
    puts ""
    puts "player cards: #{player.card_names}"
    puts "player total: #{player.calculate_total}"
    puts ""
    puts "dealer cards: #{dealer.card_names}"
    puts "dealer total: #{dealer.calculate_total}"
    puts ""
    declare_winner
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

  def shuffle_shoe
    deck.cards += discards
    self.discards = []
    deck.cards.shuffle!
  end

  def reset
    clear_screen
    self.discards += player.hand + dealer.hand
    if deck.cards.size <= 26
      shuffle_shoe
    end
    player.hand = []
    dealer.hand = []
  end

  def goodbye_message
    clear_screen
    puts "Thanks for playing Twenty-One! Goodbye!"
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
  def card_names
    hand.map(&:name).join(", ")
  end

  def win?
    calculate_total == 21
  end

  def busted?
    calculate_total > 21
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

class Player
  include Hand
  attr_accessor :hand

  def initialize
    @hand = []
  end
end

class Dealer
  include Hand
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def stay?
    calculate_total >= 17
  end
end

game = Game.new
game.start

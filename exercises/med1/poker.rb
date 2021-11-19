=begin
In the previous two exercises, you developed a Card class and a Deck class. You are now going to use those classes to create and evaluate poker hands. Create a class, PokerHand, that takes 5 cards from a Deck of Cards and evaluates those cards as a Poker hand. If you've never played poker before, you may find this overview of poker hands useful.

The exact cards and the type of hand will vary with each run.

Most variants of Poker allow both Ace-high (A, K, Q, J, 10) and Ace-low (A, 2, 3, 4, 5) straights. For simplicity, your code only needs to recognize Ace-high straights.

If you are unfamiliar with Poker, please see this description of the various hand types. Since we won't actually be playing a game of Poker, it isn't necessary to know how to play.

=end
require 'pry-byebug'

class Card
  include Comparable
  FACE_CARD_VALUE = { "Jack" => 11, "Queen" => 12, "King" => 13, "Ace" => 14 }
  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

 def determine_rank_value
   FACE_CARD_VALUE.keys.include?(rank) ? FACE_CARD_VALUE[rank] : rank
 end

 def <=>(other)
   determine_rank_value <=> other.determine_rank_value
 end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_accessor :deck

  def initialize
    @deck = create_deck
    shuffle
  end

  def draw
    self.deck = create_deck if deck.size == 0
    deck.shift
  end
  
  private
  def shuffle
    deck.shuffle!
  end

  def create_deck
    new_deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        new_deck << Card.new(rank, suit)
      end
    end
    new_deck
  end
end

class PokerHand
  attr_accessor :deck, :hand
  def initialize(deck)
    @deck = deck
    @hand = deal_hand
  end

  def print
    hand.each {|card| puts card }
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    low_card = hand.min.determine_rank_value
    low_card == 10 && straight? && flush?
  end

  def straight_flush?
    straight? && flush?
  end

  def four_of_a_kind?
    counts = []
    ranks = hand.map { |card| card.rank }
    Deck::RANKS.each do |rank|
      counts << ranks.count(rank)
    end
    counts.count(4) == 1 ? true : false
  end

  def full_house?
    three_of_a_kind? && pair?
  end

  def flush?
    suit = hand.first.suit
    hand.all? { |card| card.suit == suit }
  end

  def straight?
    range = (hand.min.determine_rank_value..hand.max.determine_rank_value).to_a
    sorted_hand_ranks = hand.map { |card| card.determine_rank_value }.sort
    range == sorted_hand_ranks
  end

  def three_of_a_kind?
    counts = []
    ranks = hand.map { |card| card.rank }
    Deck::RANKS.each do |rank|
      counts << ranks.count(rank)
    end
    counts.count(3) == 1 ? true : false
  end

  def two_pair?
    counts = []
    ranks = hand.map { |card| card.rank }
    Deck::RANKS.each do |rank|
      counts << ranks.count(rank)
    end
    counts.count(2) == 2 ? true : false
  end

  def pair?
    counts = []
    ranks = hand.map { |card| card.rank }
    Deck::RANKS.each do |rank|
      counts << ranks.count(rank)
    end
    counts.count(2) == 1 ? true : false
  end

  def deal_hand
    cards = []
    5.times { cards << deck.draw }
    cards
  end
end


hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'

=begin
5 of Clubs
7 of Diamonds
Ace of Hearts
7 of Clubs
5 of Spades
Two pair
true
true
true
true
true
true
true
true
true
true
true
true
true
=end
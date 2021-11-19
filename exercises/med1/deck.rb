=begin
Using the Card class from the previous exercise, create a Deck class that contains all of the standard 52 playing cards. 

The Deck class should provide a #draw method to deal one card. The Deck should be shuffled when it is initialized and, if it runs out of cards, it should reset itself by generating a new set of 52 shuffled cards.

Note that the last line should almost always be true; if you shuffle the deck 1000 times a second, you will be very, very, very old before you see two consecutive shuffles produce the same results. If you get a false result, you almost certainly have something wrong.
=end

class Card
  include Comparable
  FACE_CARD_VALUE = { "Jack" => 11, "Queen" => 12, "King" => 13, "Ace" => 14 }
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
#
# def determine_rank_value
#   FACE_CARD_VALUE.keys.include?(rank) ? FACE_CARD_VALUE[rank] : rank
# end
#
# def <=>(other)
#   determine_rank_value <=> other.determine_rank_value
# end
#
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

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
drawn.count { |card| card.rank == 5 } == 4
drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.
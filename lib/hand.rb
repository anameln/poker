class Hand
  def self.get_hand(deck)
    Hand.new(deck.take(5))
  end

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  HAND_VALUES = [
  :straight_flush,
  :four_of_a_kind,
  :full_house,
  :flush,
  :straight,
  :three_of_a_kind,
  :two_pair,
  :one_pair,
  :high_card
].reverse


  def beats?(other_hand)
    us = HAND_VALUES.find_index(parse[0])
    opponent = HAND_VALUES.find_index(other_hand.parse[0])
    return true if us > opponent
    return false if us < opponent
    if parse[1] > other_hand.parse[1]
      true
    elsif parse[1] < other_hand.parse[1]
      false
    else
      raise "It's a tie."
    end
  end

  def parse
    return [:straight_flush, is_straight?] if is_straight? && is_flush?
    return [:flush, is_flush?] if is_flush?
    return [:straight, is_straight?] if is_straight?
    return [:four_of_a_kind, four_of_a_kind?] if four_of_a_kind?
    return [:full_house, full_house?] if full_house?
    return [:three_of_a_kind, three_of_a_kind?] if three_of_a_kind?
    return [:two_pair, two_pair?] if two_pair?
    return [:one_pair, one_pair?] if one_pair?
    [:high_card, values.max]

  end

  def values
    cards.map{ |card| card.poker_value}.sort
  end

  def suits
    cards.map{ |card| card.suit}
  end

  def is_straight?
    (values[0]..(values[0]+4)).to_a == values ? values.max : false
  end

  def is_flush?
    suits.uniq.size == 1 ? values.max : false
  end

  def groups_of_values
    h = Hash.new(0)
    values.each do |value|
      h[value] += 1
    end
    h
  end

  def four_of_a_kind?
    groups_of_values.values.sort == [1,4] ? high_card : false
  end

  def full_house?
    groups_of_values.values.sort == [2,3] ? high_card : false
  end

  def three_of_a_kind?
    groups_of_values.values.sort == [1,1,3] ? high_card : false
  end

  def two_pair?
    return false unless groups_of_values.values.sort == [1,2,2]
    groups_of_values.select{ |k,v| v == 2 }.keys
  end

  def one_pair?
    groups_of_values.values.sort == [1,1,1,2] ? high_card : false
  end

  def high_card
    highest_card = groups_of_values.max_by{ |k,v| v }[0]
  end

end

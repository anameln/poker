require 'hand.rb'
require 'card.rb'

describe Hand do
  let(:deck) do
    double("deck", :cards => [
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack),
      Card.new(:hearts, :four),
      Card.new(:hearts, :jack)
    ])
  end

  it "has 5 cards" do
    expect(deck).to receive(:take).with(5).and_return(deck.cards)
    hand = Hand.get_hand(deck)
    expect(hand.cards.length).to eq(5)
  end

  it "detects a straight flush" do
    hand = Hand.new([
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack),
      Card.new(:spades, :ten),
      Card.new(:spades, :nine)
    ])

    expect(hand.parse).to eq([:straight_flush, 13])
  end

  it "detects flush" do
    hand = Hand.new([
      Card.new(:spades, :king),
      Card.new(:spades, :seven),
      Card.new(:spades, :jack),
      Card.new(:spades, :ten),
      Card.new(:spades, :nine)
    ])

    expect(hand.parse).to eq([:flush, 13])
  end

  it "detects a straight" do
    hand = Hand.new([
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:hearts, :jack),
      Card.new(:spades, :ten),
      Card.new(:spades, :nine)
    ])

    expect(hand.parse).to eq([:straight, 13])
  end

  it "detects four of a kind" do
    hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :king),
      Card.new(:hearts, :king),
      Card.new(:spades, :king),
      Card.new(:spades, :nine)
    ])

    expect(hand.parse).to eq([:four_of_a_kind, 13])
  end

  it "detects a full house" do
    hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :king),
      Card.new(:hearts, :king),
      Card.new(:hearts, :ten),
      Card.new(:spades, :ten)
    ])

    expect(hand.parse).to eq([:full_house, 13])
  end

  it "detects three of a kind" do
    hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :king),
      Card.new(:hearts, :king),
      Card.new(:hearts, :nine),
      Card.new(:spades, :ten)
    ])

    expect(hand.parse).to eq([:three_of_a_kind, 13])
  end

  it "detects two pair" do
    hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :king),
      Card.new(:hearts, :nine),
      Card.new(:hearts, :ten),
      Card.new(:spades, :ten)
    ])

    expect(hand.parse).to eq([:two_pair, [10, 13]])
  end

  it "detects one pair" do
    hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :king),
      Card.new(:hearts, :nine),
      Card.new(:hearts, :ten),
      Card.new(:spades, :seven)
    ])

    expect(hand.parse).to eq([:one_pair, 13])
  end

  it "returns high card if nothing better" do
    hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :ace),
      Card.new(:hearts, :nine),
      Card.new(:hearts, :ten),
      Card.new(:spades, :seven)
    ])

    expect(hand.parse).to eq([:high_card, 14])
  end

  it "finds the winner when compared to another hand" do
    hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :king),
      Card.new(:hearts, :nine),
      Card.new(:hearts, :ten),
      Card.new(:spades, :seven)
    ])

    other_hand = Hand.new([
      Card.new(:clubs, :king),
      Card.new(:diamonds, :ace),
      Card.new(:hearts, :nine),
      Card.new(:hearts, :seven),
      Card.new(:spades, :seven)
    ])

    expect(hand.beats?(other_hand)).to eq(true)
  end
end

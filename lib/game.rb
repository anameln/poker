require_relative 'deck.rb'

class Game
  def initialize(number_of_players)
    @deck = Deck.new
    @players = create_players(number_of_players)

  end

  def create_players(number_of_players)
    players = []
    number_of_players.times { |i| players << Player.new(i) }
    players
  end

  def play

  end


end

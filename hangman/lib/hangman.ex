defmodule Hangman do

  alias Hangman.Game
  defdelegate new_game(), to: Game
  defdelegate tally(game), to: Game

  def move(game, guess) do
    game = Game.move(game, guess)
    { game, Game.tally(game) }
  end
end

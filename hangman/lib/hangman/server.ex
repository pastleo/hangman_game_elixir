defmodule Hangman.Server do

  use GenServer
  alias Hangman.Game

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  # ===

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call({:move, guess}, _from, game) do
    Game.move(game, guess)
    |> (&{:reply, Game.tally(&1), &1}).()
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Game.tally(game), game}
  end
end

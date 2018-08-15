defmodule Hangman do

  def new_game() do
    {:ok, game_pid} = Supervisor.start_child(Hangman.Supervisor, [])
    game_pid
  end

  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def move(game_pid, guess) do
    GenServer.call(game_pid, {:move, guess})
  end

end

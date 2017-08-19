defmodule TextClient.Interact do
  alias TextClient.State

  def start() do
    Hangman.new_game()
    |>  init_state()
  end

  defp init_state(game) do
    %State{
      game_service: game,
      tally:        Hangman.tally(game),
    }
  end
end

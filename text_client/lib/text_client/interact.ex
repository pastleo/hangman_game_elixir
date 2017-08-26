defmodule TextClient.Interact do
  alias TextClient.{State, Player}

  def start() do
    Hangman.new_game()
    |> init_state()
    |> play()
  end

  defp init_state(game) do
    %State{
      game_service: game,
      tally:        Hangman.tally(game),
    }
  end

  defp play(game) do
    Player.play(game)
  end
end

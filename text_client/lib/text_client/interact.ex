defmodule TextClient.Interact do
  alias TextClient.{State, Player}
  @hangman_server :hangman@pc

  def start() do
    new_game()
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

  defp new_game() do
    Node.connect(@hangman_server)
    :rpc.call(@hangman_server, Hangman, :new_game, [])
  end
end

# cd hangman
# iex --sname hangman -S mix
#
# hangman > :observer.start
# check observer application tab
#
# cd text_client
# iex --sname c1 -S mix
# iex --sname c2 -S mix
#
# c1 > TextClient.start
# c1 > play hangman...
#
# c2 > TextClient.start
# c2 > play hangman...

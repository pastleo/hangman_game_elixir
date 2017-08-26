defmodule TextClient.Mover do

  alias TextClient.State
  
  def move(game = %State{ game_service: game_service, guessed: guessed }) do
    { gs, tally } = Hangman.move(game_service, guessed)
    %State{
      game |
      game_service: gs,
      tally: tally,
    }
  end

end

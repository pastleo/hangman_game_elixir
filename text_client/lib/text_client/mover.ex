defmodule TextClient.Mover do

  alias TextClient.State
  
  def move(state = %State{ game_service: game_service, guessed: guessed }) do
    Hangman.move(game_service, guessed)
    |> (&%State{ state | tally: &1 }).()
  end

end

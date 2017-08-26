defmodule TextClient.Summary do

  alias TextClient.State
  
  def display(game = %State{ tally: tally }) do
    IO.puts [
      "\n",
      "Letters:  #{letters(game.tally.letters)}\n",
      "Left:     #{tally.left_turns}\n",
      "You have guessed: #{letters(game.tally.used)}",
    ]
    game
  end

  defp letters(letters) do
    Enum.join(letters, " ")
  end
end

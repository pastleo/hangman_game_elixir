defmodule TextClient.Prompter do
  alias TextClient.State
  
  def accept_move(game = %State{}) do
    IO.gets(">> ")
    |> String.trim()
    |> check(game)
  end

  defp check({:error, reason}, _) do
    IO.puts("Game died: #{reason}")
    exit(:normal)
  end

  defp check({:eof}, _) do
    IO.puts("Bye... QAQ")
    exit(:normal)
  end

  defp check(input, game = %State{}) do
    cond do
      single_a2z?(input) ->
        Map.put(game, :guessed, input)
      true ->
        IO.puts("Invalid input")
        accept_move(game)
    end
  end

  #defp check(input, game) when single_a2z?(input), do: String.trim(input)
  #defp check(_, game) do
    #IO.puts("Invalid input")
    #accept_move
  #end

  defp single_a2z?(input) do
    input =~ ~r/\A[a-z]\z/
  end

end

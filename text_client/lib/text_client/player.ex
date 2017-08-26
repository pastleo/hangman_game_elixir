defmodule TextClient.Player do
  alias TextClient.{State, Summary, Prompter, Mover}

  def play(%State{tally: %{ state: :won }}) do
    bye("You won")
  end

  def play(%State{tally: %{ state: :lose }}) do
    bye("You lose")
  end

  def play(game = %State{tally: %{ state: :good_guess }}) do
    continue_with_msg(game, "Good guess")
  end
  
  def play(game = %State{tally: %{ state: :bad_guess }}) do
    continue_with_msg(game, "Bad guess")
  end
  
  def play(game = %State{tally: %{ state: :already_used }}) do
    continue_with_msg(game, "Already used")
  end

  def play(game) do
    continue(game)
  end

  defp continue_with_msg(game, msg) do
    IO.puts(msg)
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.move()
    |> play()
  end

  defp bye(msg) do
    IO.puts(msg)
    exit(:normal)
  end

end

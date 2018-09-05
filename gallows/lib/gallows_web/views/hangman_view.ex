defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  defp letters(letters) do
    Enum.join(letters, " ")
  end

  defp hangman_info(:init), do: "New game started"
  defp hangman_info(:lose), do: "You lose..."
  defp hangman_info(:won), do: "You won!"
  defp hangman_info(:good_guess), do: "Good guess"
  defp hangman_info(:bad_guess), do: "Bad guess"
  defp hangman_info(:already_used), do: "Already used"
  defp hangman_info(:guess_isnt_valid), do: "Not valid input"

  defp turn(left, target) when left <= target, do: "opacity: 1"
  defp turn(left, target), do: "opacity: 0.25"

end

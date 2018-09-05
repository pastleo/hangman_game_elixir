defmodule Hangman.Game do

  defstruct(
    left_turns: 7,
    game_state: :init,
    letters: [],
    used: MySet.new()
  )

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints
    }
  end
  
  def new_game() do
    new_game(Dic.random())
  end

  def move_with_tally(game, guess) do
    move(game, guess)
    |> (&{ &1, tally(&1) }).()
  end

  def move(game = %Hangman.Game{ game_state: :won }, _guess), do: game
  def move(game = %Hangman.Game{ game_state: :lose }, _guess), do: game
  
  def move(game, guess) when is_binary(guess) do
    accept_move(
      game,
      guess,
      is_single_ascii_char_str(guess),
      MySet.member?(game.used, guess)
    )
  end

  def move(game, _guess), do: game

  def tally(game) do
    %{
      state: game.game_state,
      left_turns: game.left_turns,
      letters: game.letters |> reveal_guessed(game.used),
      used: game.used,
    }
  end

  # =========
  
  defp is_single_ascii_char_str(str) do
    Regex.match?(~r/\A[a-z]\z/, str)
  end

  defp accept_move(game, _guess, _guess_is_single_char = false, _already_guessed) do
    Map.put(game, :game_state, :guess_isnt_valid)
  end
  
  defp accept_move(game, _guess, _guess_is_single_char, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end
  
  defp accept_move(game, guess, _guess_is_single_char, _already_guessed) do
    Map.put(game, :used, MySet.put(game.used, guess))
    |> score(MySet.member?(game.letters, guess))
  end

  defp score(game, _good_guess = true) do
    new_state = MapSet.subset?(
      MapSet.new(game.letters),
      MapSet.new(game.used)
    ) |> may_won()

    Map.put(game, :game_state, new_state)
  end

  defp score(game = %{ left_turns: 1 }, _not_good_guess) do
    %{ game |
      game_state: :lose,
      left_turns: 0
    }
  end

  defp score(game, _not_good_guess) do
    %{ game |
      game_state: :bad_guess,
      left_turns: game.left_turns - 1
    }
  end

  defp may_won(true), do: :won
  defp may_won(_),    do: :good_guess

  #defp reveal_guessed([ cur | left], used) do
    #if MySet.member?(used, cur) do
      #[ cur | reveal_guessed(left, used) ]
    #else
      #[ "_" | reveal_guessed(left, used) ]
    #end
  #end
  
  #defp reveal_guessed([], _used) do
    #[]
  #end

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MySet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _in_used = true),   do: letter
  defp reveal_letter(_letter, _in_used = false), do: "_"
end

defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman
  alias Hangman.Game

  def check_leatters_ascii([cur | tail]) do
    if cur >= "a" && cur <= "z" do
      check_leatters_ascii(tail)
    else
      false
    end
  end
  def check_leatters_ascii([]), do: true

  test "game init" do
    new_game = Game.new_game()
    assert new_game.game_state == :init
    assert new_game.left_turns == 7
    assert check_leatters_ascii(new_game.letters)
  end

  test "game already won wont move" do
    game = Game.new_game()
    game_before = Map.put(game, :game_state, :won)
    game_after = Game.move(game_before, "x")
    assert game_before == game_after
  end

  test "invalid guess will get :guess_isnt_valid" do
    for guess <- ["xa", "B", ":", "asd", "呦"] do
      game =
        Game.new_game()
        |> Game.move(guess)
      assert game.game_state == :guess_isnt_valid
    end
  end

  test "first guess is not already used" do
    game = Game.new_game()
    game = Game.move(game, "x")
    assert game.game_state != :already_used
  end

  test "second same guess is already used" do
    game = Game.new_game()
    game = Game.move(game, "x")
    game = Game.move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    moves = [
      {"g", :good_guess},
      {"a", :good_guess},
      {"m", :good_guess},
      {"e", :won}
    ]
    Enum.reduce(
      moves,
      Game.new_game("game"),
      fn ({ guess, state}, game) ->
        game = Game.move(game, guess)
        assert game.game_state == state
        game
      end
    )
  end
  
  test "a bad guess is recognized" do
    game = Game.new_game("game")
    game = Game.move(game, "x")
    assert game.game_state == :bad_guess
    assert game.left_turns == 6
  end

  test "using up left_turns lead to lose the game" do
    moves = [
      {"x", :bad_guess},
      {"b", :bad_guess},
      {"d", :bad_guess},
      {"e", :bad_guess},
      {"f", :bad_guess},
      {"y", :bad_guess},
      {"h", :lose}
    ]
    Enum.reduce(
      moves,
      Game.new_game("a"),
      fn ({ guess, state}, game) ->
        game = Game.move(game, guess)
        assert game.game_state == state
        game
      end
    )
  end

  test "tally should reveal good guess" do
    tally =
      Game.new_game("asdf")
      |> Game.move("a")
      |> Game.move("x")
      |> Game.tally
    assert tally.left_turns == 6
    assert tally.letters == ["a", "_", "_", "_"]
  end

  test "move_with_tally" do
    game =
      Game.new_game("asdf")
      |> Game.move("a")
    game_next = Game.move(game, "x")
    assert Game.move_with_tally(game, "x") == { game_next, Game.tally(game_next) }
  end
end

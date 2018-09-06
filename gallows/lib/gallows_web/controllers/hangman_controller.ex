defmodule GallowsWeb.HangmanController do
  use GallowsWeb, :controller

  def new(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, _params) do
    game = Hangman.new_game()

    conn
    |> put_session(:game, game)
    |> assign(:tally, Hangman.tally(game))
    |> render("edit.html")
  end

  def move(conn, %{"move" => %{"guess" => guessed }}) do
    game = get_session(conn, :game)
    tally = Hangman.move(game, guessed)

    assign(conn, :tally, tally)
    |> Map.put(:params, %{})
    |> render_move_result(tally)
  end

  defp render_move_result(conn, %{ state: :won }) do
    render(conn, "show.html")
  end

  defp render_move_result(conn, %{ state: :lose }) do
    render(conn, "show.html")
  end

  defp render_move_result(conn, _tally) do
    render(conn, "edit.html")
  end

end

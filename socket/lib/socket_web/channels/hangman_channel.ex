defmodule SocketWeb.HangmanChannel do
  use Phoenix.Channel

  def join("hangman:game", _, socket) do
    socket
    |> assign(:game, Hangman.new_game())
    |> (&{:ok, &1}).()
  end

  def handle_in("tally", _, socket) do
    push(socket, "tally", Hangman.tally(socket.assigns.game))
    {:noreply, socket}
  end

  def handle_in("move", guessed, socket) do
    tally = Hangman.move(socket.assigns.game, guessed)
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  def handle_in("new", _, socket) do
    game = Hangman.new_game()
    push(socket, "tally", Hangman.tally(game))
    socket
    |> assign(:game, game)
    |> (&{:noreply, &1}).()
  end
end

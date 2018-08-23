defmodule HelloPhxWeb.PageView do
  use HelloPhxWeb, :view

  def plural(word, 1), do: "a #{word}"
  def plural(word, count), do: "#{count} #{word}s"
end

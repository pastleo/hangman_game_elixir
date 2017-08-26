defmodule Dic.WordList do
  def words() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split
  end

  def random(words) do
    words
    |> Enum.random
  end
end

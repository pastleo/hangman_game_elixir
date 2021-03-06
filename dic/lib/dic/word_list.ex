defmodule Dic.WordList do

  def start_link() do
    Agent.start_link(&words/0, name: __MODULE__)
  end

  def random() do
    Agent.get(__MODULE__, &Enum.random/1)
  end

  defp words() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split
  end
end

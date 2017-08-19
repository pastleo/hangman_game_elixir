defmodule Dic do
  def words do
    "../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!
    |> String.split
  end

  def random do
    words
    |> Enum.random
  end

  def swap({a ,b}) do
    {b, a}
  end

  def eq?(a ,a) do
    true
  end
  
  def eq?(_ ,_) do
    false
  end

  def len([]), do: 0
  def len([_|t]), do: 1 + len(t)

  def map([], func), do: []
  def map([h|t], func), do: [func.(h) | map(t, func)]

  def sum_pairs([]), do: []
  def sum_pairs([a, b | t]), do: [ a + b | sum_pairs(t) ]

  def even_length?([]), do: true
  def even_length?([_]), do: false
  def even_length?([_,_|t]), do: even_length?(t)

end

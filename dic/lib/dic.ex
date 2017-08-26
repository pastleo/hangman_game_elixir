defmodule Dic do

  alias Dic.WordList
  defdelegate start(), to: WordList, as: :words
  defdelegate random(words), to: WordList

end

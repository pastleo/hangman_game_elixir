defmodule Dic do

  alias Dic.WordList
  defdelegate start(), to: WordList, as: :start_link
  defdelegate random(), to: WordList

end

defmodule MySetTest do
  use ExUnit.Case
  doctest MySet
  alias MySet

  test "new/0 should generate a empty list" do
    assert MySet.new() == []
  end

  test "put/2 should return a new list" do
    assert MySet.put([], :asdf) == [:asdf]
  end

  test "member?" do
    assert MySet.member?([:asdf], :asdf) == true
    assert MySet.member?([:asdf], :asdff) == false
  end
end

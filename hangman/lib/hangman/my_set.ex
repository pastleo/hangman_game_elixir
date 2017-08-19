defmodule MySet do
  def new() do
    []
  end

  def member?([head | rest], key) do
    if head == key do
      true
    else
      member?(rest, key)
    end
  end
  
  def member?([], _key) do
    false
  end

  def put(set, key) do
    [key | set]
  end
end

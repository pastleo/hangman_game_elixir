defmodule Dic.Application do
  use Application

  def start(_type, _args) do
    Dic.start()
  end
end

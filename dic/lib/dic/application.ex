defmodule Dic.Application do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      worker(Dic.WordList, [])
    ]

    options = [
      name: Dic.Supervisor,
      strategy: :one_for_one,
    ]

    Supervisor.start_link(children, options)
  end
end

defmodule NodeDemo do
  def reverse do
    receive do
      msg ->
        String.reverse(msg)
        |> IO.puts
    end
    reverse()
  end

  def reverse_sending_back do
    receive do
      {from_pid, msg} ->
        IO.inspect(from_pid)
        String.reverse(msg)
        |> (&send(from_pid, &1)).()
    end
    reverse_sending_back()
  end

  # ===

  def start_chain_link(next_node, sleep_timeout \\ 1000) do
    spawn_link(__MODULE__, :chain, [next_node, sleep_timeout]) |> Process.register(:chainer)
  end

  def trigger_chain(count \\ 4) do
    send(:chainer, { [], count })
  end

  # ===

  def chain(next_node, sleep_timeout) do
    receive do
      { _list, 0 } = state ->
        IO.inspect(state)
        IO.puts("done")
      { list, count } = state ->
        IO.inspect(state)
        Process.sleep(sleep_timeout)
        send({ :chainer, next_node }, { [ next_node | list ], count - 1 })
    end
    chain(next_node, sleep_timeout)
  end
end

# $ iex --sname foo -S mix
# $ iex --sname bar -S mix
#
# foo > Node.connect(:bar@elite) # this is not necessary, will automatically connect when sending
#
# bar > Node.spawn(:foo@elite, fn -> IO.puts("hello") end)
# bar : hello
# bar > Node.spawn(:foo@elite, fn -> IO.inspect(self()) end)
# bar : #PID<14749.148.0>
#
# bar > pid = spawn(NodeDemo, :reverse, [])
# bar > send(pid, "qwer")
# bar : rewq
# bar > Process.register(pid, :rev)
#
# foo > send({:rev, :bar@elite}, "asdf")
# bar : fdsa
#
# bar > pid = spawn(NodeDemo, :reverse_sending_back, [])
# bar > Process.register(pid, :rev_sb)
# bar > send(:rev_sb, {self(), "zxcv"})
# bar : #PID<0.137.0>
# bar > flush()
# bar : "vcxz"
#
# foo > send({:rev_sb, :bar@elite}, {self(), "ghry"})
# bar : #PID<14749.127.0>
# foo > flush()
# foo : "yrhg"
#
# foo > NodeDemo.start_chain_link(:bar@elite)
# bar > NodeDemo.start_chain_link(:foo@elite)
# foo > NodeDemo.trigger_chain
# bar : {[:bar@elite], 3}
# foo : {[:foo@elite, :bar@elite], 2}
# bar : {[:bar@elite, :foo@elite, :bar@elite], 1}
# foo : {[:foo@elite, :bar@elite, :foo@elite, :bar@elite], 0}
# foo : done

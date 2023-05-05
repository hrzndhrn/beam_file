defmodule Elixir.PlusPlus do
  def foo(a, b) do
    :erlang.++(a, do: [b: b], end: [b: b])
  end
end

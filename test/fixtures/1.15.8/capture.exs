defmodule Elixir.Capture do
  def fun do
    fn x1, x2 -> :erlang.+(:erlang.*(x1, x2), x1) end
  end

  def double do
    fn x1 -> :erlang.+(x1, x1) end
  end
end

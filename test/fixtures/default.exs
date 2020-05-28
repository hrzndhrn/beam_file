defmodule Elixir.Default do
  def go(x) do
    x
  end

  def go do
    go(42000)
  end

  def gogo(a, x, y) do
    :erlang.+(:erlang.+(a, x), y)
  end

  def gogo(x0, x1) do
    gogo(x0, x1, 1000)
  end

  def gogo(x0) do
    gogo(x0, 666_000, 1000)
  end
end

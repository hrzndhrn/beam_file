defmodule Default do
  def go(x \\ 42_000), do: x

  def gogo(a, x \\ 666_000, y \\ 1_000), do: a + x + y
end

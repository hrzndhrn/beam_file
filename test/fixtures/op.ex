defmodule Elixir.Op do
  def +value do
    :erlang.+(value)
  end

  def left &&& right do
    :erlang.band(left, right)
  end

  defmacro unquote(:%)(struct, map) do
    {struct, map}
  end

  defmacro first..last//step do
    {first, last, step}
  end

  defmacro !{:!, _, [value]} do
    {:ok, value}
  end

  defmacro !value do
    {:ok, value}
  end
end

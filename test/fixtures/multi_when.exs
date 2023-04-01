defmodule Elixir.MultiWhen do
  def call(x) when :erlang.>(x, 0) when :erlang.<(x, 0) do
    x
  end
end

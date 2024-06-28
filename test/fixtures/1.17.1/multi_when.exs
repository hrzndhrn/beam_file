defmodule Elixir.MultiWhen do
  def call(x) when :erlang.>(x, 0) when :erlang.<(x, 0) do
    x
  end

  def call2(x)
      when :erlang.>(x, 0)
      when :erlang.<(x, 0)
      when :erlang.<(x, 10)
      when :erlang.>(x, -10) do
    x
  end
end

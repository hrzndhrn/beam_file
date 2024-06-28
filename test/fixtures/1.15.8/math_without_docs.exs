defmodule Elixir.Math do
  def add(number_a, number_b) do
    :erlang.+(number_a, number_b)
  end

  def double(number) do
    add({number, number})
  end

  def triple(number) do
    :erlang.*(3, number)
  end

  defp add(nums) do
    {number_a, number_b} = nums
    add(number_a, number_b)
  end

  def divide(a, b) when :erlang."/="(b, 0) do
    :erlang.div(a, b)
  end

  defmacro biggest(a, b) do
    {:max, [context: Math, imports: [{2, Kernel}]], [a, b]}
  end

  def odd_or_even(a) do
    case :erlang.==(:erlang.rem(a, 2), 0) do
      false -> :odd
      true -> :even
    end
  end

  def pi do
    Math.Const.pi()
  end
end

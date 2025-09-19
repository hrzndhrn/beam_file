defmodule Elixir.Math do
  @moduledoc """
  Math is Fun
  """

  @doc """
  Adds up two numbers.
  """
  def add(number_a, number_b) do
    :erlang.+(number_a, number_b)
  end

  @doc """
  Doubles a number.
  """
  def double(number) do
    add({number, number})
  end

  @doc """
  Triples a number.
  """
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

  @doc """
  Returns the biggest.
  """
  defmacro biggest(a, b) do
    {:max, [context: Math, imports: [{2, Kernel}]],
     [:elixir_quote.shallow_validate_ast(a), :elixir_quote.shallow_validate_ast(b)]}
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

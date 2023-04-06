defmodule Math do
  @moduledoc """
  Math is Fun
  """

  alias Math.Const

  @typedoc "number"
  @type num :: integer()
  @opaque x :: num()

  @typep num_tuple :: {num(), num()}

  @three 3

  @doc """
  Adds up two numbers.
  """
  @spec add(num() | num_tuple(), num()) :: x()
  def add(number_a, number_b) do
    number_a + number_b
  end

  @doc """
  Doubles a number.
  """
  @spec double(num()) :: x()
  def double(number), do: add({number, number})

  @doc """
  Triples a number.
  """
  @spec triple(num()) :: x()
  def triple(number), do: @three * number

  @spec add(num_tuple()) :: x()
  defp add(nums) do
    {number_a, number_b} = nums
    add(number_a, number_b)
  end

  @spec divide(num(), num()) :: x()
  def divide(a, b) when b != 0 do
    div(a, b)
  end

  @doc """
  Returns the biggest.
  """
  defmacro biggest(a, b) do
    quote do
      max(unquote(a), unquote(b))
    end
  end

  def odd_or_even(a) do
    if rem(a, 2) == 0 do
      :even
    else
      :odd
    end
  end

  def pi, do: Const.pi()
end

defmodule Math.Const do
  def pi, do: :math.pi()
end

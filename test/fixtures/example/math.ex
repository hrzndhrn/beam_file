defmodule Example.Math do
  @moduledoc "Math is Fun"

  def add(number_a, number_b), do: number_a + number_b

  def odd_or_even(a) do
    if rem(a, 2) == 0 do
      :even
    else
      :odd
    end
  end
end

defmodule PlusPlus do
  def foo(a, b) do
    a ++ [do: [b: b], end: [b: b]]
  end
end

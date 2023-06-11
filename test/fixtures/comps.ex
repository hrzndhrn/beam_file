defmodule Comps do
  def fun_one do
    for n <- [1, 2, 3], do: n * n
  end

  def fun_two do
    for n <- [1, 2, 3], into: [], do: n * n
  end

  def fun_two do
    for n <- [1, 2, 3], into: %{}, do: {n, n * n}
  end
end

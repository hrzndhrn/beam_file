defmodule Elixir.Comps do
  def fun_one do
    for n <- [1, 2, 3] do
      :erlang.*(n, n)
    end
  end

  def fun_two do
    for n <- [1, 2, 3], into: [] do
      :erlang.*(n, n)
    end
  end

  def fun_three do
    for n <- [1, 2, 3], into: %{} do
      {n, :erlang.*(n, n)}
    end
  end
end

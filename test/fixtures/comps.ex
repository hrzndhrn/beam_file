defmodule Comps do
  def one do
    for n <- [1, 2, 3], do: n * n
  end

  def two do
    for n <- [1, 2, 3], into: [], do: n * n
  end

  def three do
    for n <- [1, 2, 3], into: %{}, do: {n, n * n}
  end

  def four do
    for i <- [1, 2, 3],
        n <- [1, 2, 3],
        into: %{},
        do: {i, n}
  end

  def five do
    for <<x <- "abcabc">>, uniq: true, into: "", do: <<x - 32>>
  end

  def six do
    for <<x <- "AbCabCABc">>, x in ?a..?z, reduce: %{} do
      acc -> Map.update(acc, <<x>>, 1, &(&1 + 1))
    end
  end

  def users(users) do
    for {type, name} when type != :guest <- users do
      String.upcase(name)
    end
  end
end

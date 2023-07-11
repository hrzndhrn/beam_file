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

  def seven do
    for(x <- [1, 2], do: x) ++ for y <- [3, 4], do: y
  end

  def eight do
    for(x <- [1, 2], do: x) -- for y <- [3, 4], do: y
  end

  def nine(list) do
    list ++ Enum.sort(for x <- [1, 2], do: x)
  end

  def ten(list) do
    :erlang.++(list, Enum.sort(for x <- [1, 2], do: x))
  end

  def eleven(list) do
    :erlang.--(list, Enum.sort(for x <- [1, 2], do: x))
  end

  def users(users) do
    for {type, name} when type != :guest <- users do
      String.upcase(name)
    end
  end
end

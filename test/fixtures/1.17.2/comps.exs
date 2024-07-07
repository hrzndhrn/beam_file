defmodule Elixir.Comps do
  def one do
    for n <- [1, 2, 3], into: [], do: :erlang.*(n, n)
  end

  def two do
    for n <- [1, 2, 3], into: [], do: :erlang.*(n, n)
  end

  def three do
    for n <- [1, 2, 3], into: %{}, do: {n, :erlang.*(n, n)}
  end

  def four do
    for i <- [1, 2, 3], n <- [1, 2, 3], into: %{}, do: {i, n}
  end

  def five do
    for <<(<<x>> <- "abcabc")>>, uniq: true, into: "", do: <<:erlang.-(x, 32)>>
  end

  def six do
    for <<(<<x>> <- "AbCabCABc")>>,
        :erlang.andalso(
          :erlang.is_integer(x),
          :erlang.andalso(:erlang.>=(x, 97), :erlang."=<"(x, 122))
        ),
        reduce: %{},
        do: (acc -> Map.update(acc, <<x>>, 1, fn capture -> :erlang.+(capture, 1) end))
  end

  def seven do
    :erlang.++(for(x <- [1, 2], into: [], do: x), for(y <- [3, 4], into: [], do: y))
  end

  def eight do
    :erlang.--(for(x <- [1, 2], into: [], do: x), for(y <- [3, 4], into: [], do: y))
  end

  def nine(list) do
    :erlang.++(list, Enum.sort(for x <- [1, 2], into: [], do: x))
  end

  def ten(list) do
    :erlang.++(list, Enum.sort(for x <- [1, 2], into: [], do: x))
  end

  def eleven(list) do
    :erlang.--(list, Enum.sort(for x <- [1, 2], into: [], do: x))
  end

  def users(users) do
    for {type, name} when :erlang."/="(type, :guest) <- users, into: [], do: String.upcase(name)
  end
end

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
        do: (acc -> Map.update(acc, <<x>>, 1, fn x1 -> :erlang.+(x1, 1) end))
  end

  def users(users) do
    for {type, name} when :erlang."/="(type, :guest) <- users, into: [], do: String.upcase(name)
  end
end

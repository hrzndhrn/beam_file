defmodule Elixir.Comps do
  def one do
    for n <- [1, 2, 3] do
      :erlang.*(n, n)
    end
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
          :erlang.andalso(
            :erlang.>=(
              x,
              97
            ),
            :erlang."=<"(
              x,
              122
            )
          )
        ),
        reduce: %{},
        do: (acc -> Map.update(acc, <<x>>, 1, fn x1 -> :erlang.+(x1, 1) end))
  end

  def seven do
    :erlang.++(
      for x <- [1, 2] do
        x
      end,
      for y <- [3, 4] do
        y
      end
    )
  end

  def eight do
    :erlang.--(
      for x <- [1, 2] do
        x
      end,
      for y <- [3, 4] do
        y
      end
    )
  end

  def nine(list) do
    :erlang.++(
      list,
      Enum.sort(
        for x <- [1, 2] do
          x
        end
      )
    )
  end

  def ten(list) do
    :erlang.++(
      list,
      Enum.sort(
        for x <- [1, 2] do
          x
        end
      )
    )
  end

  def eleven(list) do
    :erlang.--(
      list,
      Enum.sort(
        for x <- [1, 2] do
          x
        end
      )
    )
  end

  def users(users) do
    for {type, name} when :erlang."/="(type, :guest) <- users do
      String.upcase(name)
    end
  end
end

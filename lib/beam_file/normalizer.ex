defmodule BeamFile.Normalizer do
  @moduledoc false

  alias Code.Normalizer

  @chars Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z) ++ Enum.to_list(?0..?9) ++ [??, ?!, ?_]
  @none_unquotes [
    :{},
    :->,
    :<<>>,
    :!,
    :/,
    :!=,
    :!==,
    :"..//",
    :"//",
    :"::",
    :"<|>",
    :"^^^",
    :&&&,
    :&&,
    :&,
    :+++,
    :++,
    :+,
    :-,
    :--,
    :---,
    :..,
    :<,
    :<-,
    :<<<,
    :<<~,
    :<<~,
    :<=,
    :<>,
    :<~,
    :<~>,
    :=,
    :=,
    :==,
    :===,
    :=~,
    :>,
    :>=,
    :>>>,
    :\\,
    :in,
    :|,
    :|>,
    :||,
    :|||,
    :~>,
    :~>,
    :~>>,
    :~>>
  ]

  def normalize(block) when is_list(block), do: Enum.map(block, &normalize/1)

  def normalize({:do, block}) do
    {:do, normalize(block)}
  end

  def normalize({a, b}), do: {normalize(a), normalize(b)}

  def normalize({:.., meta, args}) do
    case args do
      Elixir -> {:"(..)", meta, args}
      [{a, _, nil}, {b, _, nil}] -> {String.to_atom("#{a}..#{b}"), meta, args}
    end
  end

  def normalize({:super, meta, args}) do
    {{_kind, name}, meta} = Keyword.pop!(meta, :super)

    if unquote?(name) do
      {{:unquote, meta, [name]}, meta, normalize(args)}
    else
      {name, meta, args}
    end
  end

  def normalize({{:., meta1, [:erlang, :++]}, meta2, [left, right]}) do
    left = Normalizer.normalize(left)
    right = Normalizer.normalize(right)

    {{:., meta1, [:erlang, :++]}, meta2, [left, right]}
  end

  def normalize({{:., meta1, [:erlang, :binary_to_atom]}, meta2, [arg, :utf8]}) do
    {{:., meta1, [:erlang, :binary_to_atom]}, meta2, [arg, {:__block__, [], [:utf8]}]}
  end

  def normalize({:for, meta, args}) when is_list(args) do
    {args, [last]} = Enum.split(args, -1)
    # put the :do to the end of the keyword list
    block = Keyword.fetch!(last, :do)
    last = last |> Keyword.delete(:do) |> Enum.concat([{:do, block}])
    {:for, meta, args ++ [last]}
  end

  def normalize({expr, meta, args}) do
    if unquote?(expr) do
      {{:unquote, [], [expr]}, meta, normalize(args)}
    else
      {expr, meta, normalize(args)}
    end
  end

  def normalize(block), do: block

  defp unquote?(atom) when atom in @none_unquotes, do: false
  defp unquote?(atom) when is_atom(atom), do: atom |> to_string() |> unquote?()
  defp unquote?(<<>>), do: false
  defp unquote?(<<char, rest::binary>>) when char in @chars, do: unquote?(rest)
  defp unquote?(str) when is_binary(str), do: true
  defp unquote?(_expr), do: false
end

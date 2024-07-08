defmodule BeamFile.Normalizer do
  @moduledoc false

  @chars Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z) ++ Enum.to_list(?0..?9) ++ [??, ?!, ?_]
  @none_unquotes [
    :%{},
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

  def normalize(block, target) when is_list(block) do
    if Keyword.keyword?(block) do
      Enum.map(block, fn {key, value} -> {key, normalize(value, target)} end)
    else
      Enum.map(block, fn expr -> normalize(expr, target) end)
    end
  end

  def normalize({:do, block}, target) do
    {:do, normalize(block, target)}
  end

  def normalize({a, b}, target), do: {normalize(a, target), normalize(b, target)}

  def normalize({:.., meta, args}, _target) do
    case args do
      Elixir -> {:"(..)", meta, args}
      [{a, _, nil}, {b, _, nil}] -> {String.to_atom("#{a}..#{b}"), meta, args}
    end
  end

  def normalize({:capture, meta, nil} = ast, :code) do
    case Keyword.get(meta, :counter) do
      {_module, count} -> {:"capture#{count}", meta, nil}
      _else -> ast
    end
  end

  def normalize({:super, meta, args}, target) do
    case Keyword.has_key?(meta, :super) do
      true ->
        {{_kind, name}, meta} = Keyword.pop!(meta, :super)

        if unquote?(name) do
          {{:unquote, meta, [name]}, meta, normalize(args, target)}
        else
          {name, meta, args}
        end

      false ->
        {:super, meta, args}
    end
  end

  def normalize({{:., meta1, [:erlang, :++]}, meta2, [left, right] = args}, :code = target) do
    if (Keyword.keyword?(left) and Keyword.has_key?(left, :do)) or
         (Keyword.keyword?(right) and Keyword.has_key?(right, :do)) do
      left = left |> normalize(target) |> Code.Normalizer.normalize()
      right = right |> normalize(target) |> Code.Normalizer.normalize()
      {{:., meta1, [:erlang, :++]}, meta2, [left, right]}
    else
      {{:., meta1, [:erlang, :++]}, meta2, normalize(args, target)}
    end
  end

  if Version.match?(System.version(), "~> 1.13.0") do
    # In Elixir 1.13 the original AST throws an error in the formatter.
    # ** (CaseClauseError) no case clause matching: :utf8
    # :utf8 is replaced with the equivalent AST {:__block__, [], [:utf8]}
    def normalize({{:., meta1, [:erlang, :binary_to_atom]}, meta2, [arg, :utf8]}, :code) do
      {{:., meta1, [:erlang, :binary_to_atom]}, meta2, [arg, {:__block__, [], [:utf8]}]}
    end
  end

  def normalize({:for, meta, args}, target) when is_list(args) do
    {args, [last]} = Enum.split(args, -1)

    case Keyword.keyword?(last) do
      true ->
        # put the :do to the end of the keyword list
        block = Keyword.fetch!(last, :do)
        last = last |> Keyword.delete(:do) |> Enum.concat([{:do, block}])

        args = normalize(args ++ [last], target)
        {:for, meta, args}

      false ->
        {:for, meta, args}
    end
  end

  def normalize({expr, meta, args}, target) do
    cond do
      unquote?(expr) ->
        {{:unquote, [], [expr]}, meta, normalize(args, target)}

      var_ref?(expr) ->
        {var_ref(expr), meta, normalize(args, target)}

      true ->
        {expr, meta, normalize(args, target)}
    end
  end

  def normalize(block, _target), do: block

  defp var_ref?(ref) when is_atom(ref), do: Regex.match?(~r/^\&\d+$/, to_string(ref))
  defp var_ref?(_), do: false

  defp var_ref(ref), do: ref |> to_string() |> String.replace("&", "x") |> String.to_atom()

  defp unquote?(atom) when atom in @none_unquotes, do: false
  defp unquote?(atom) when is_atom(atom), do: atom |> to_string() |> unquote?()
  defp unquote?(<<>>), do: false
  defp unquote?("&" <> str), do: !Regex.match?(~r/^\d*$/, str)
  defp unquote?(<<char, rest::binary>>) when char in @chars, do: unquote?(rest)
  defp unquote?(str) when is_binary(str), do: true
  defp unquote?(_expr), do: false
end

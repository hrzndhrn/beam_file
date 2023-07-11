defmodule BeamFile.DebugInfo do
  @moduledoc false

  alias BeamFile.Normalizer

  @default_lang "en"

  def ast(%{module: module} = debug_info, target \\ :ast) do
    ast = debug_info |> definitions(:desc) |> Enum.map(fn {_name, _arity, ast} -> ast end)

    Normalizer.normalize(
      {:defmodule, [context: Elixir, import: Kernel],
       [
         {:__aliases__, [alias: false], [module]},
         [do: {:__block__, [], ast}]
       ]},
      target
    )
  end

  def code(debug_info, docs) do
    to_code(
      debug_info.module,
      moduledoc(docs),
      definitions(debug_info),
      defdocs(docs)
    )
  end

  defp definitions(%{definitions: definitions}, sorter \\ :asc) do
    definitions
    |> Enum.sort_by(
      fn {{_name, arity}, _kind, meta, _block} -> {meta[:line], arity * -1} end,
      sorter
    )
    |> definition(sorter, [])
    |> List.flatten()
  end

  defp definition([], _sorter, acc), do: acc

  defp definition([{{name, arity}, kind, meta, bodies} | definitions], sorter, acc) do
    bodies =
      Enum.map(bodies, fn {_meta, args, guard, block} ->
        {name, arity, {kind, meta, body(name, args, guard, block)}}
      end)

    definition = if sorter == :asc, do: Enum.reverse(bodies), else: bodies

    definition(definitions, sorter, [definition | acc])
  end

  defp body(:%, args, guard, block) do
    body({:unquote, [], [:%]}, args, guard, block)
  end

  defp body(name, args, guard, block) do
    args = if Enum.empty?(args), do: Elixir, else: args

    [guards(guard, {name, [], args}), [do: block]]
  end

  defp guards([], expr), do: expr

  defp guards([guard], expr) do
    {:when, [], [expr, guard]}
  end

  defp guards([guard | guards], expr) do
    {:when, [], [expr, guards(guards, guard)]}
  end

  defp to_code(module, moduledoc, defs, defdocs) do
    code = defs_to_code(defs, defdocs, [])

    """
    defmodule #{module} do
      #{doc(:module, moduledoc)}

      #{code}
    end
    """
    |> Code.format_string!()
    |> IO.iodata_to_binary()
  end

  defp defs_to_code([], _, acc), do: Enum.join(acc, "\n")

  defp defs_to_code([{name, arity, ast} | defs], defdocs, acc) do
    {defdoc, defdocs} = defdoc(name, arity, defdocs)
    code = ast |> Normalizer.normalize(:code) |> Macro.to_string()

    defs_to_code(defs, defdocs, [defdoc, code | acc])
  end

  defp moduledoc({moduledoc, _context, _defdocs}) when is_map(moduledoc) do
    Map.get(moduledoc, @default_lang)
  end

  defp moduledoc({_moduledoc, _context, _defdocs}), do: nil

  defp doc(_type, nil), do: ""

  defp doc(type, doc) do
    multiline = String.contains?(doc, "\n")
    doc(type, doc, multiline)
  end

  defp doc(type, doc, true) do
    {sigil, delimiter} =
      case {String.contains?(doc, ~S|"""|), String.contains?(doc, ~S|#{|)} do
        {false, false} -> {"", ~S|"""|}
        {true, false} -> {"~s", ~S|'''|}
        {false, true} -> {"~S", ~S|"""|}
        {true, true} -> {"~S", ~S|'''|}
      end

    """
    #{doc(type)} #{sigil}#{delimiter}
    #{doc}\
    #{delimiter}\
    """
  end

  defp doc(type, doc, false) do
    {sigil, delimiter} =
      case {String.contains?(doc, ~S|"|), String.contains?(doc, ~S|#{|)} do
        {false, false} -> {"", ~S|"|}
        {true, false} -> {"~s", ~S|'|}
        {false, true} -> {"~S", ~S|"|}
        {true, true} -> {"~S", ~S|'|}
      end

    "#{doc(type)} #{sigil}#{delimiter}#{doc}#{delimiter}"
  end

  defp doc(:module), do: "@moduledoc"
  defp doc(:def), do: "@doc"

  defp defdocs({_moudle, _context, docs}) do
    docs
    |> Enum.reduce([], fn
      {{kind, name, arity}, line, _code, docs, _opts}, acc
      when kind in [:function, :macro] and is_map(docs) ->
        doc = Map.get(docs, @default_lang)
        [{name, arity, doc, line} | acc]

      _doc, acc ->
        acc
    end)
    |> Enum.sort_by(fn {_name, _arity, _doc, line} -> line end, :desc)
  end

  defp defdoc(name, arity, [{name, arity, text, _line} | docs]) do
    {doc(:def, text), docs}
  end

  defp defdoc(_name, _arity, docs) do
    {"", docs}
  end
end

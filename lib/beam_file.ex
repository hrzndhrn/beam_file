defmodule BeamFile do
  @moduledoc """
  An interface to the BEAM file format.

  This module is mainly a wrapper around Erlangs `:beam_lib`.

  Furthermore, different code representations can be generated from the file.
  - `BeamFile.abstract_code/1`
  - `BeamFile.byte_code/1`
  - `BeamFile.erl_code/1`
  - `BeamFile.elixir_code/2`
  """

  @type info :: [
          file: Path.t(),
          module: module(),
          chunks: [{charlist(), non_neg_integer(), non_neg_integer()}]
        ]

  @type chunk_name :: charlist()

  @type chunk_id ::
          :abstract_code
          | :atoms
          | :attributes
          | :compile_info
          | :debug_info
          | :docs
          | :elixir_checker
          | :exports
          | :imports
          | :indexed_imports
          | :labeled_exports
          | :labeled_locals
          | :locals

  @type chunk :: chunk_id | chunk_name

  @default_lang "en"

  @blank " "
  @new_line "\n"
  @new_paragraph "\n\n"

  @doc_ -2
  # @spec_ -1
  @fun 0
  @args 1
  @super 2
  @guards 3
  @block 4

  @chunk_names [
    :abstract_code,
    # 'Atom'
    :atoms,
    # 'Attr'
    :attributes,
    # 'CInf'
    :compile_info,
    # 'Dbgi'
    :debug_info,
    # 'ExpT'
    :exports,
    # 'ImpT'
    :imports,
    # 'ImpT'
    :indexed_imports,
    # 'ExpT'
    :labeled_exports,
    # 'LocT'
    :labeled_locals,
    # 'LocT'
    :locals
  ]

  @extra_chunk_names %{
    docs: 'Docs',
    elixir_checker: 'ExCk'
  }

  @extra_chunk_keys Map.keys(@extra_chunk_names)
  @extra_chunk_values Map.values(@extra_chunk_names)

  @doc """
  Returns the absolute filename for the `module`.

  If the module cannot be found, `{:error, :non_existing}` is returned.

  If the module is preloaded, `{:error, :preloaded}` is returned.

  If the module is Cover-compiled, `{:error, :cover_compiled}` is returned.
  """
  @spec which(module()) ::
          {:ok, String.t()} | {:error, :non_existing | :preloaded | :cover_compiled}
  def which(module) do
    case :code.which(module) do
      [_ | _] = path -> {:ok, IO.chardata_to_string(path)}
      error -> {:error, error}
    end
  end

  @doc """
  Returns a keyword list containing some information about a BEAM file.

  - `:file`: The name of the BEAM file, or the binary from which the information
    was extracted.
  - `:module`: The name of the module.
  - `:chunks`: For each chunk, the identifier and the position and size of the
    chunk data, in bytes.
  """
  @spec info(Path.t() | module()) :: info()
  def info(input) do
    with {:ok, path} <- path(input) do
      path
      |> :beam_lib.info()
      |> Keyword.update!(:file, fn path -> IO.chardata_to_string(path) end)
    end
  end

  @doc """
  Returns infos for the given chunk reference.
  """
  @spec chunk(Path.t() | module(), chunk()) :: {:ok, term()} | {:error, any()}
  def chunk(input, chunk) do
    with {:ok, path} <- path(input),
         {:ok, chunk} <- to_chunk(chunk),
         {:ok, {_module, [{_chunk, data}]}} <- fetch_chunks(path, [chunk]) do
      data =
        case chunk in @extra_chunk_values do
          true -> :erlang.binary_to_term(data)
          false -> data
        end

      {:ok, data}
    else
      {:error, :beam_lib, reason} -> {:error, reason}
      {:error, _} = error -> error
    end
  end

  @doc """
  Returns chunk data for all chunks.
  """
  @spec chunks(Path.t() | module()) :: {:ok, map()} | {:error, any()}
  def chunks(input) do
    with {:ok, path} <- path(input),
         {:ok, _module, chunks} <- :beam_lib.all_chunks(path) do
      {:ok, Enum.into(chunks, %{})}
    end
  end

  @doc """
  Returns chunk data for all chunk names.
  """
  def chunks(input, :named) do
    with {:ok, path} <- path(input) do
      @chunk_names
      |> Enum.concat(@extra_chunk_keys)
      |> Enum.into(%{}, fn name ->
        case chunk(path, name) do
          {:ok, chunk} -> {name, chunk}
          error -> {name, error}
        end
      end)
    end
  end

  @doc """
  Returns the Erlang code for the BEAM file.
  """
  @spec erl_code(Path.t() | module()) :: {:ok, String.t()} | {:error, any()}
  def erl_code(input) do
    with {:ok, abstract_code} <- abstract_code(input) do
      code =
        abstract_code
        |> :erl_syntax.form_list()
        |> :erl_prettypr.format()
        |> to_string()

      {:ok, code}
    end
  end

  @doc """
  Returns the byte code for the BEAM file.
  """
  @spec byte_code(Path.t() | module()) :: {:ok, String.t()} | {:error, any()}
  def byte_code(input) do
    with {:ok, data} <- read(input) do
      {:ok, :beam_disasm.file(data)}
    end
  end

  @doc """
  Returns the binary for the given BEAM file.
  """
  @spec read(Path.t() | module()) :: {:ok, binary()} | {:error, File.posix()}
  def read(input) do
    with {:ok, path} <- path(input) do
      File.read(path)
    end
  end

  @doc """
  Returns elixir code recreated from the `debug_info` chunk.

  The recreated code comes with resolved macros and references.
  For now, types and specs will not be recreated.

  Options:
  `:docs`: With `docs: false` the docs will not be created.
  """
  @spec elixir_code(Path.t() | module(), keyword()) :: {:ok, String.t()} | {:error, any}
  def elixir_code(input, opts \\ []) do
    with {:ok, {debug_info, _meta}} <- debug_info(input) do
      code =
        debug_info
        |> definitions()
        |> docs(input, opts)
        |> to_code(debug_info)

      {:ok, code}
    end
  end

  @doc """
  Returns the `Dbgi`/`:debug_info` chunk.
  """
  @spec debug_info(module()) :: {:ok, term()} | {:error, any}
  def debug_info(module) when is_atom(module) do
    case chunk(module, :debug_info) do
      {:ok, {:debug_info_v1, _backend, {:elixir_v1, debug_info, data}}} ->
        {:ok, {debug_info, data}}

      {:ok, result} ->
        {:error, {:unexpected, result}}

      error ->
        error
    end
  end

  @doc """
  Returns the `:abstract_code` chunk.
  """
  @spec abstract_code(Path.t() | module()) :: {:ok, term()} | {:error, any}
  def abstract_code(input) do
    case chunk(input, :abstract_code) do
      {:ok, {:raw_abstract_v1, abstract_code}} ->
        {:ok, abstract_code}

      {:ok, result} ->
        {:error, {:unexpected, result}}

      error ->
        error
    end
  end

  @doc """
  Returns the `:docs` chunk.
  """
  @spec docs(Path.t() | module()) :: {:ok, term()} | {:error, any}
  def docs(input) do
    case chunk(input, :docs) do
      {:ok, {:docs_v1, _, :elixir, "text/markdown", doc, meta, docs}} ->
        {:ok, {doc, meta, docs}}

      {:ok, result} ->
        {:error, {:unexpected, result}}

      error ->
        error
    end
  end

  defp fetch_chunks(path, chunks), do: :beam_lib.chunks(path, chunks, [:allow_missing_chunks])

  defp to_chunk(chunk) when chunk in @extra_chunk_keys do
    {:ok, Map.fetch!(@extra_chunk_names, chunk)}
  end

  defp to_chunk(chunk) when chunk in @chunk_names, do: {:ok, chunk}

  defp to_chunk(chunk) when is_binary(chunk), do: {:ok, to_charlist(chunk)}

  defp to_chunk(chunk) when is_list(chunk), do: {:ok, chunk}

  defp to_chunk(_), do: {:error, :invalid_chunk}

  defp path(path) when is_binary(path) do
    {:ok, to_charlist(path)}
  end

  defp path(module) when is_atom(module) do
    case :code.which(module) do
      [_ | _] = path ->
        {:ok, path}

      [] ->
        {:error, :beam_file_not_found}

      error ->
        {:error, error}
    end
  end

  defp path(path) when is_list(path), do: {:ok, path}

  defp path(_), do: {:error, :not_found}

  defp definitions(%{definitions: definitions}) do
    definitions
    |> Enum.with_index()
    |> Enum.flat_map(fn {{{name, _arity}, kind, _meta, clauses}, def_index} ->
      clauses
      |> Enum.with_index()
      |> Enum.flat_map(fn {{meta, args, guards, block}, clause_index} ->
        index = def_index + clause_index / (length(clauses) + 1)

        meta =
          meta
          |> Keyword.put(:name, name)
          |> Keyword.put(:kind, kind)

        [
          fun(meta, index),
          args(args, meta, index),
          guards(guards, meta, index),
          block(block, meta, index)
        ]
      end)
    end)
  end

  defp fun(meta, index) do
    line = line(meta)
    kind = meta[:kind]
    name = meta[:name]
    code = [to_string(kind), @blank, to_string(name)]

    {code, {line, index, @fun}}
  end

  defp args(args, meta, index) do
    line = line(meta)

    code =
      args
      |> Enum.map(&code_to_string/1)
      |> case do
        [] -> @blank
        code -> ["(", Enum.join(code, ", "), ")", @blank]
      end

    {code, {line, index, @args}}
  end

  defp guards([], _, _), do: :none

  defp guards(guards, meta, index) do
    line = line(meta)

    code = Enum.map(guards, &code_to_string/1)

    {[@blank, "when ", code, @blank], {line, index, @guards}}
  end

  defp block({:__block__, [], block}, meta, index), do: do_block(block, meta, index)

  defp block({:super, context, args}, meta, index) do
    line = line(meta)
    code = code_to_string({meta[:name], context, args})
    code = ["do", @new_line, code, @new_line, "end", @new_paragraph]

    {code, {line, index, @super}}
  end

  defp block(block, meta, index) do
    line = line(meta)
    code = ["do", @new_line, code_to_string(block), @new_line, "end", @new_paragraph]
    {code, {line, index, @block}}
  end

  defp do_block(block, meta, index) when is_list(block) do
    line = line(meta)
    code = Enum.map_join(block, @new_line, &code_to_string/1)
    code = ["do", @new_line, code, @new_line, "end", @new_paragraph]

    {code, {line, index, @block}}
  end

  defp docs(code, module, opts) do
    with {:docs, true} <- {:docs, Keyword.get(opts, :docs, true)},
         {:ok, docs} <- docs(module) do
      Enum.concat([
        code,
        moduledoc(docs),
        fundocs(docs)
      ])
    else
      _ -> code
    end
  end

  defp fundocs({_doc, _meta, []}), do: [:none]

  defp fundocs({_doc, _meta, docs}) do
    Enum.map(docs, fn
      {_fun, _line, _code, :none, _meta} ->
        :none

      {_fun, _line, _code, :hidden, _meta} ->
        :none

      {_fun, line, _code, doc, _meta} ->
        case Map.fetch(doc, @default_lang) do
          :error ->
            :none

          {:ok, doc} ->
            doc = """
            @doc \"""
            #{doc}
            \"""
            """

            {doc, {line, 0, @doc_}}
        end
    end)
  end

  defp moduledoc({doc, _, _}) when doc in [:none, :hidden], do: [:none]

  defp moduledoc({doc, _, _}) do
    case Map.fetch(doc, @default_lang) do
      {:ok, str} ->
        str = """
        \"""
        #{str}
        \"""
        """

        code = ["@moduledoc", @blank, str, @new_paragraph]

        {code, {0, 0, @doc_}}

      :error ->
        :none
    end
    |> List.wrap()
  end

  defp line(meta), do: Keyword.get(meta, :line, 0)

  defp code_to_string(code), do: Macro.to_string(code)

  defp to_code(data, debug_info) do
    module = Map.get(debug_info, :module) |> to_string()

    code =
      data
      |> Enum.filter(fn
        :none -> false
        _ -> true
      end)
      |> sort()
      |> strip()
      |> IO.iodata_to_binary()

    """
    defmodule #{module} do
      #{code}
    end
    """
    |> Code.format_string!()
    |> IO.iodata_to_binary()
  end

  defp sort(data) do
    Enum.sort(data, fn
      {_, {line, index, ord_a}}, {_, {line, index, ord_b}} -> ord_a <= ord_b
      {_, {line, index_a, _}}, {_, {line, index_b, _}} -> index_a <= index_b
      {_, {line_a, _, _}}, {_, {line_b, _, _}} -> line_a <= line_b
    end)
  end

  defp strip(data), do: Enum.map(data, fn {iodata, _} -> iodata end)
end

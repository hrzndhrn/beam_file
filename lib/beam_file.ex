defmodule BeamFile do
  @moduledoc """
  An interface to the BEAM file format.

  This module is mainly a wrapper around Erlangs `:beam_lib`.

  For more information see the Erlang documentation for the module
  [`beam_lib`](https://www.erlang.org/doc/man/beam_lib.html)

  Furthermore, different code representations can be generated from the file.
  - `BeamFile.abstract_code/1`
  - `BeamFile.byte_code/1`
  - `BeamFile.erl_code/1`
  - `BeamFile.elixir_code/2`
  - `BeamFile.elixir_quoted/1`

  To use the functions above with a module name the module must be compiled
  and loaded. The functions can also be used with the binary of a module.
  """

  alias BeamFile.DebugInfo
  alias BeamFile.Error

  @type info :: [
          file: Path.t() | binary(),
          module: module(),
          chunks: [{charlist(), non_neg_integer(), non_neg_integer()}]
        ]

  @type path :: charlist()

  @type beam :: path() | binary()

  @type input ::
          beam()
          | module()
          | {:module, module(), binary(), any()}
          | [{module(), binary()}]

  @type reason :: any()

  @typedoc """
  Chunk ID.

  ```
  'Abst'
  | 'Attr'
  | 'AtU8'
  | 'CInf'
  | 'Dbgi'
  | 'Dcos'
  | 'ExCk'
  | 'ExpT'
  | 'ImpT'
  | 'LocT'
  ```
  """
  @type chunk_id :: charlist()

  @type chunk_name ::
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

  @type chunk_ref :: chunk_name | chunk_id

  @chunk_ids [
    ~c"Abst",
    ~c"AtU8",
    ~c"Attr",
    ~c"CInf",
    ~c"Dbgi",
    ~c"Docs",
    ~c"ExCk",
    ~c"ExpT",
    ~c"ImpT",
    ~c"LocT"
  ]

  @chunk_names [
    :abstract_code,
    :atoms,
    :attributes,
    :compile_info,
    :debug_info,
    :docs,
    :elixir_checker,
    :exports,
    :imports,
    :indexed_imports,
    :labeled_exports,
    :labeled_locals,
    :locals
  ]

  @since_default Version.parse_requirement!(">= 0.0.0")

  @doc """
  Returns the `:abstract_code` chunk.

  ## Examples

      iex> BeamFile.abstract_code(BeamFile.Example)
      {
        :ok,
        [
          {:attribute, 1, :file, {~c"test/fixtures/example.ex", 1}},
          {:attribute, 1, :module, BeamFile.Example},
          {:attribute, 1, :compile, [:no_auto_import]},
          {:attribute, 1, :export, [__info__: 1, hello: 0]},
          {
            :attribute,
            1,
            :spec,
            {
              {:__info__, 1},
              [
                {
                  :type,
                  1,
                  :fun,
                  [
                    {
                      :type,
                      1,
                      :product,
                      [
                        {
                          :type,
                          1,
                          :union,
                          [
                            {:atom, 1, :attributes},
                            {:atom, 1, :compile},
                            {:atom, 1, :functions},
                            {:atom, 1, :macros},
                            {:atom, 1, :md5},
                            {:atom, 1, :exports_md5},
                            {:atom, 1, :module},
                            {:atom, 1, :deprecated},
                            {:atom, 1, :struct}
                          ]
                        }
                      ]
                    },
                    {:type, 1, :any, []}
                  ]
                }
              ]
            }
          },
          {
            :function,
            0,
            :__info__,
            1,
            [
              {:clause, 0, [{:atom, 0, :module}], [], [{:atom, 0, BeamFile.Example}]},
              {
                :clause,
                0,
                [{:atom, 0, :functions}],
                [],
                [{:cons, 0, {:tuple, 0, [{:atom, 0, :hello}, {:integer, 0, 0}]}, {nil, 0}}]
              },
              {:clause, 0, [{:atom, 0, :macros}], [], [nil: 0]},
              {:clause, 0, [{:atom, 0, :struct}], [], [{:atom, 0, nil}]},
              {
                :clause,
                0,
                [{:atom, 0, :exports_md5}],
                [],
                [
                  {
                    :bin,
                    0,
                    [
                      {
                        :bin_element,
                        0,
                        {:string, 0,
                          [166, 117, 1, 22, 146, 56, 30, 199, 203, 141, 158, 223, 3, 11, 225, 190]},
                        :default,
                        :default
                      }
                    ]
                  }
                ]
              },
              {
                :clause,
                0,
                [{:match, 0, {:var, 0, :Key}, {:atom, 0, :attributes}}],
                [],
                [
                  {
                    :call,
                    0,
                    {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
                    [{:atom, 0, BeamFile.Example}, {:var, 0, :Key}]
                  }
                ]
              },
              {
                :clause,
                0,
                [{:match, 0, {:var, 0, :Key}, {:atom, 0, :compile}}],
                [],
                [
                  {
                    :call,
                    0,
                    {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
                    [{:atom, 0, BeamFile.Example}, {:var, 0, :Key}]
                  }
                ]
              },
              {
                :clause,
                0,
                [{:match, 0, {:var, 0, :Key}, {:atom, 0, :md5}}],
                [],
                [
                  {
                    :call,
                    0,
                    {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
                    [{:atom, 0, BeamFile.Example}, {:var, 0, :Key}]
                  }
                ]
              },
              {:clause, 0, [{:atom, 0, :deprecated}], [], [nil: 0]}
            ]
          },
          {:function, {2, 7}, :hello, 0, [{:clause, {2, 7}, [], [], [{:atom, {2, 7}, :world}]}]}
        ]
      }
  """
  @spec abstract_code(input()) :: {:ok, term()} | {:error, any()}
  def abstract_code(input) do
    with {:ok, {:raw_abstract_v1, abstract_code}} <- chunk(input, :abstract_code) do
      {:ok, abstract_code}
    end
  end

  @doc """
  Same as `abstract_code/1` but raises `BeamFile.Error`
  """
  @spec abstract_code!(input()) :: term()
  def abstract_code!(input) do
    case abstract_code(input) do
      {:ok, abstract_code} ->
        abstract_code

      {:error, reason} ->
        raise Error, """
        Abstract code for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns chunk data for all chunks.

  The `type` argument forces the use of `:ids` or `:names`, defaults to `:names`.

  ## Examples

      iex> {:ok, chunks} = BeamFile.all_chunks(BeamFile.Example, :names)
      iex> chunks |> Map.keys() |> Enum.sort()
      [
        :abstract_code,
        :atoms,
        :attributes,
        :compile_info,
        :debug_info,
        :docs,
        :elixir_checker,
        :exports,
        :imports,
        :indexed_imports,
        :labeled_exports,
        :labeled_locals,
        :locals
      ]
      iex> {:docs_v1, 1, :elixir, "text/markdown", :none, _meta, docs} = Map.get(chunks, :docs)
      iex> docs
      [{{:function, :hello, 0}, 2, ["hello()"], :none, %{source_annos: [{2, 7}]}}]

      iex> {:ok, chunks} = BeamFile.all_chunks(BeamFile.Example, :ids)
      iex> chunks |> Map.keys() |> Enum.sort()
      [~c"Abst", ~c"AtU8", ~c"Attr", ~c"CInf", ~c"Dbgi", ~c"Docs", ~c"ExCk", ~c"ExpT", ~c"ImpT", ~c"LocT"]
      iex> chunks |> Map.get(~c"Docs") |> is_binary()
      true
  """
  @spec all_chunks(input(), type :: :names | :ids) :: {:ok, map()} | {:error, any()}
  def all_chunks(input, type \\ :names) when type in [:ids, :names] do
    with {:ok, input} <- binary(input) do
      chunks =
        case type do
          :names -> @chunk_names
          :ids -> @chunk_ids
        end

      fetch_chunks(input, chunks, type)
    end
  end

  @doc """
  Same as `all_chunks/` but raises `BeamFile.Error`
  """
  @spec all_chunks!(input(), type :: :names | :ids) :: map
  def all_chunks!(input, type \\ :names) do
    case all_chunks(input, type) do
      {:ok, chunks} ->
        chunks

      {:error, reason} ->
        raise Error, """
        Chunks for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns the byte code for the BEAM file.

  ## Examples

      iex> {:ok, byte_code} = BeamFile.byte_code(BeamFile.Example)
      iex> byte_code |> Tuple.to_list() |> Enum.take(3)
      [
        :beam_file,
        BeamFile.Example,
        [{:__info__, 1, 2}, {:hello, 0, 11}, {:module_info, 0, 13}, {:module_info, 1, 15}]
      ]
  """
  @spec byte_code(input()) :: {:ok, term()} | {:error, any()}
  def byte_code(input) do
    with {:ok, data} <- binary(input) do
      case :beam_disasm.file(data) do
        {:error, mod, reason} -> {:error, {mod, reason}}
        byte_code -> {:ok, byte_code}
      end
    end
  end

  @doc """
  Same as `byte_code/1` but raises `BeamFile.Error`
  """
  @spec byte_code!(input()) :: term()
  def byte_code!(input) do
    case byte_code(input) do
      {:ok, byte_code} ->
        byte_code

      {:error, reason} ->
        raise Error, """
        Byte code for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns infos for the given chunk reference.

  ## Examples

      iex> BeamFile.chunk(BeamFile.Example, :exports)
      {:ok, [__info__: 1, hello: 0, module_info: 0, module_info: 1]}

      iex> {:ok, chunk} = BeamFile.chunk(BeamFile.Example, ~c"Dbgi")
      iex> is_binary(chunk)
      true
  """
  @spec chunk(input(), chunk_ref()) :: {:ok, term()} | {:error, any()}
  def chunk(input, chunk) when chunk in @chunk_ids or chunk in @chunk_names do
    with {:ok, input} <- binary(input) do
      type =
        cond do
          chunk in @chunk_names -> :names
          chunk in @chunk_ids -> :ids
        end

      with {:ok, data} <- fetch_chunks(input, [chunk], type) do
        [{_key, value}] = Map.to_list(data)
        {:ok, value}
      end
    end
  end

  @doc """
  Same as `chunk/2` but raises `BeamFile.Error`
  """
  @spec chunk!(input(), chunk_ref()) :: term
  def chunk!(input, chunk) do
    case chunk(input, chunk) do
      {:ok, data} ->
        data

      {:error, reason} ->
        raise Error, """
        Chunk #{inspect(chunk)} for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns the infos from the  `:debug_info` chunk.

  Examples:

      iex> {:ok, info} = BeamFile.debug_info(BeamFile.Example)
      iex> info |> Map.get(:definitions) |> hd() |> elem(0)
      {:hello, 0}
      iex> Map.get(info, :relative_file)
      "test/fixtures/example.ex"

  """
  @spec debug_info(input()) :: {:ok, term()} | {:error, any}
  def debug_info(input) do
    with {:ok, {:debug_info_v1, backend, data}} <- chunk(input, :debug_info) do
      case data do
        {:elixir_v1, debug_info, _meta} ->
          backend.debug_info(:elixir_v1, debug_info.module, data, [])

        :none ->
          {:error, :no_debug_info}
      end
    end
  end

  @doc """
  Same as `debug_info/1` but raises `BeamFile.Error`
  """
  @spec debug_info!(input()) :: term()
  def debug_info!(input) do
    case debug_info(input) do
      {:ok, debug_info} ->
        debug_info

      {:error, reason} ->
        raise Error, """
        Debug info for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns the infos from the `:docs` chunk.

  ## Options

    * `format` - the output format. The format `:info` reduces the output to the
      type and the infos `:since`, `:hidden` and `:deprecated`. The format `since`
      reduces the output to the type and the info `:since`.

    * `hidden` - indicates whether only hidden or none hidden items are returned.
      Without the option hidden and none hidden items are returned.

    * `deprecated` - indicates whether only deprecated or none deprecated items are
      returned. Without the option deprecated and none deprecated items are returned.

    * `since` - expected a version requirement. With `since`, the function returns
      all items whose since attribute matches `since`. When `since` does not match
      the module attribute since and not any item in the module matches, the tuple
      `{:ok, nil}` is returned.

  ## Examples

      iex> {:ok, {:none, _meta, docs}} = BeamFile.docs(BeamFile.Example)
      iex> docs
      [{{:function, :hello, 0}, 2, ["hello()"], :none, %{source_annos: [{2, 7}]}}]

  Examples with options:

      iex> BeamFile.docs(Float, format: :info, deprecated: true)
      {:ok,
       {[
          {{:function, :to_char_list, 1}, [since: nil, hidden: true, deprecated: true]},
          {{:function, :to_char_list, 2}, [since: nil, hidden: true, deprecated: true]},
          {{:function, :to_string, 2}, [since: nil, hidden: true, deprecated: true]}
        ], [since: nil, hidden: false, deprecated: false]}}

      iex> BeamFile.docs(Date, format: :since, since: "~> 1.12")
      {:ok,
       {[
          {{:function, :after?, 2}, [since: "1.15.0"]},
          {{:function, :before?, 2}, [since: "1.15.0"]},
          {{:function, :range, 3}, [since: "1.12.0"]},
          {{:function, :shift, 2}, [since: "1.17.0"]}
        ], [since: nil]}}
  """
  @spec docs(input(), options :: keyword()) :: {:ok, term()} | {:error, any()}
  def docs(input, options \\ []) do
    with {:ok, {:docs_v1, _, :elixir, "text/markdown", doc, meta, docs}} <- chunk(input, :docs) do
      {:ok, docs(doc, meta, docs, options)}
    end
  end

  defp docs(doc, meta, docs, []) do
    {doc, meta, docs}
  end

  defp docs(doc, meta, docs, options) do
    since = Keyword.get(options, :since, @since_default)
    deprecated = Keyword.get(options, :deprecated)
    hidden = Keyword.get(options, :hidden, true)
    format = Keyword.get(options, :format)

    docs =
      docs
      |> docs_since(since)
      |> docs_hidden(hidden)
      |> docs_deprecated(deprecated)

    if not Enum.empty?(docs) or since_match?(meta, since) do
      docs_format(doc, meta, docs, format)
    else
      nil
    end
  end

  defp docs_since(docs, @since_default), do: docs

  defp docs_since(docs, since) do
    Enum.filter(docs, fn doc -> doc |> elem(4) |> since_match?(since) end)
  end

  defp docs_hidden(docs, hidden) do
    Enum.reject(docs, fn doc ->
      elem(doc, 3) == :hidden && !hidden
    end)
  end

  defp docs_deprecated(docs, nil), do: docs

  defp docs_deprecated(docs, deprecated) do
    Enum.filter(docs, fn doc ->
      meta = elem(doc, 4)
      deprecated?(meta) == deprecated
    end)
  end

  defp docs_format(doc, meta, docs, nil) do
    {doc, meta, docs}
  end

  defp docs_format(doc, meta, docs, format) do
    docs =
      Enum.map(docs, fn {info, _line, _name, doc, meta} ->
        {info, info(format, doc, meta)}
      end)

    {docs, info(format, doc, meta)}
  end

  defp info(:info, doc, meta) do
    [since: Map.get(meta, :since), hidden: doc == :hidden, deprecated: deprecated?(meta)]
  end

  defp info(:since, _doc, meta) do
    [since: Map.get(meta, :since)]
  end

  defp deprecated?(meta) do
    meta |> Map.get(:deprecated) |> is_binary()
  end

  defp since_match?(meta, since) when is_map(meta) do
    meta |> Map.get(:since, "0.0.0") |> normalize_version() |> Version.match?(since)
  end

  defp normalize_version(version) do
    if Regex.match?(~r/^\d+\.\d+$/, version), do: "#{version}.0", else: version
  end

  @doc """
  Same as `docs/2` but raises `BeamFile.Error`
  """
  @spec docs!(input(), options: keyword()) :: term()
  def docs!(input, options \\ []) do
    case docs(input, options) do
      {:ok, docs} ->
        docs

      {:error, reason} ->
        raise Error, """
        Docs for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc ~S'''
  Returns elixir code recreated from the `debug_info` chunk.

  The recreated code comes with resolved macros and references.
  For now, types and specs will not be recreated.

  Options:
  `:docs`: With `docs: true` the docs will be created.

  ## Examples

      iex> BeamFile.elixir_code(BeamFile.Example)
      {
        :ok,
        """
        defmodule Elixir.BeamFile.Example do
          def hello do
            :world
          end
        end\
        """
      }
  '''
  @spec elixir_code(input(), opts :: keyword()) :: {:ok, String.t()} | {:error, any}
  def elixir_code(input, opts \\ []) do
    with {:ok, debug_info} <- debug_info(input),
         {:ok, docs} <- maybe_docs(input, opts) do
      code =
        if docs do
          DebugInfo.code(debug_info, docs)
        else
          debug_info |> DebugInfo.ast(:code) |> Macro.to_string()
        end

      {:ok, code}
    end
  end

  defp maybe_docs(input, opts) do
    if Keyword.get(opts, :docs, false), do: docs(input), else: {:ok, nil}
  end

  @doc """
  Same as `elixir_code/1` but raises `BeamFile.Error`
  """
  @spec elixir_code!(input(), opts :: keyword()) :: String.t()
  def elixir_code!(input, opts \\ []) do
    case elixir_code(input, opts) do
      {:ok, code} ->
        code

      {:error, reason} ->
        raise Error, """
        Elixir code for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns the extended Elixir AST.
  """
  @spec elixir_quoted(input()) :: {:ok, Macro.t()} | {:error, any()}
  def elixir_quoted(input) do
    with {:ok, debug_info} <- debug_info(input) do
      {:ok, DebugInfo.ast(debug_info)}
    end
  end

  @doc """
  Same as `elixir_quoted/1` but raises `BeamFile.Error`
  """
  @spec elixir_quoted!(input()) :: Macro.t()
  def elixir_quoted!(input) do
    case elixir_quoted(input) do
      {:ok, ast} ->
        ast

      {:error, reason} ->
        raise Error, """
        Elixir AST for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns the Erlang code for the BEAM file.

  ## Examples

      iex> {:ok, code} = BeamFile.erl_code(BeamFile.Example)
      iex> code =~ "-module('Elixir.BeamFile.Example')"
      true
  """
  @spec erl_code(input()) :: {:ok, String.t()} | {:error, any()}
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
  Same as `erl_code/1` but raises `BeamFile.Error`
  """
  @spec erl_code!(input()) :: String.t()
  def erl_code!(input) do
    case erl_code(input) do
      {:ok, code} ->
        code

      {:error, reason} ->
        raise Error, """
        Erlang code for #{inspect(input, binaries: :as_binaries)} not available, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc """
  Returns `true` if a BEAM file for the given `module` exists.

  ## Examples

      iex> BeamFile.exists?(BeamFile.Example)
      true
      iex> BeamFile.exists?(Physics.TOE)
      false
  """
  @spec exists?(module()) :: boolean()
  def exists?(module) do
    case :code.which(module) do
      :non_existing -> false
      _path -> true
    end
  end

  @doc """
  Returns a keyword list containing some information about a BEAM file.

  - `:file`: The name of the BEAM file, or the binary from which the information
    was extracted.
  - `:module`: The name of the module.
  - `:chunks`: For each chunk, the identifier and the position and size of the
    chunk data, in bytes.

  ## Examples

      iex> {:ok, info} = BeamFile.info(BeamFile.Example)
      iex> info[:module]
      BeamFile.Example
      iex> info[:chunks]
      ...> |> Enum.map(fn {id, _pos, _size} -> id end)
      ...> |> Enum.sort()
      [
        ~c"AtU8",
        ~c"Attr",
        ~c"CInf",
        ~c"Code",
        ~c"Dbgi",
        ~c"Docs",
        ~c"ExCk",
        ~c"ExpT",
        ~c"ImpT",
        ~c"Line",
        ~c"LitT",
        ~c"LocT",
        ~c"StrT",
        ~c"Type"
      ]
  """
  @spec info(input()) :: {:ok, info()} | {:error, reason()}
  def info(input) do
    with {:ok, input} <- beam(input),
         {:ok, info} <- do_info(input) do
      {:ok, info_file(info, input)}
    end
  end

  defp info_file(info, input) when is_list(input) do
    Keyword.put(info, :file, IO.chardata_to_string(input))
  end

  defp info_file(info, _input), do: info

  defp do_info(input) do
    case :beam_lib.info(input) do
      {:error, :beam_lib, {:file_error, _path, reason}} -> {:error, reason}
      {:error, :beam_lib, reason} -> {:error, reason}
      info -> {:ok, info}
    end
  end

  @doc """
  Returns the absolute filename for the `module`.

  If the module cannot be found, `{:error, :non_existing}` is returned.

  If the module is preloaded, `{:error, :preloaded}` is returned.

  If the module is Cover-compiled, `{:error, :cover_compiled}` is returned.

  ## Examples

      iex> {:ok, path} = BeamFile.which(BeamFile.Example)
      iex> path =~ "/_build/test/lib/beam_file/ebin/Elixir.BeamFile.Example.beam"
  """
  @spec which(module()) ::
          {:ok, Path.t()}
          | {:error, :non_existing | :preloaded | :cover_compiled}
  def which(module) when is_atom(module) do
    with {:ok, path} <- path(module) do
      {:ok, path |> to_string() |> Path.relative_to_cwd()}
    end
  end

  @doc """
  Same as `which/1` but raises `BeamFile.Error`
  """
  @spec which!(module()) :: Path.t()
  def which!(module) when is_atom(module) do
    case which(module) do
      {:ok, path} ->
        path

      {:error, reason} ->
        raise Error, "Path for #{module} not available, reason: #{inspect(reason)}."
    end
  end

  @doc """
  Returns the `binary` for the given input.
  """
  @spec binary(input()) ::
          {:ok, binary()}
          | {:error, File.posix()}
          | {:error, :non_existing | :preloaded | :cover_compiled}
  def binary(input) do
    with {:ok, data} <- beam(input) do
      if is_list(data) do
        data |> List.to_string() |> File.read()
      else
        {:ok, data}
      end
    end
  end

  @doc """
  Same as `binary/1` but raises `BeamFile.Error`
  """
  @spec binary!(input()) :: binary()
  def binary!(input) do
    case binary(input) do
      {:ok, binary} ->
        binary

      {:error, reason} ->
        raise Error, """
        Can not fetch #{inspect(input, binaries: :as_binaries)}, \
        reason: #{inspect(reason, binaries: :as_binaries)}\
        """
    end
  end

  @doc false
  @deprecated "use binary/1 instead"
  def read(input), do: binary(input)

  @doc false
  @deprecated "use binary!/1 instead"
  def read!(input), do: binary!(input)

  defp fetch_chunks(input, chunks, type) when type in [:ids, :names] do
    chunks = Enum.map(chunks, &to_erl_chunk/1)

    case :beam_lib.chunks(input, chunks, [:allow_missing_chunks]) do
      {:ok, {_module, data}} ->
        data = Enum.into(data, %{}, fn item -> to_elixir_data(item, type) end)
        {:ok, data}

      {:error, :beam_lib, reason} ->
        {:error, reason}
    end
  end

  # Some chunks are not available via a chunk-name. For this chunks we need the
  # chunk-id.
  defp to_erl_chunk(:docs), do: ~c"Docs"

  defp to_erl_chunk(:elixir_checker), do: ~c"ExCk"

  defp to_erl_chunk(chunk), do: chunk

  # For some chunks we need a transformation.
  defp to_elixir_data({~c"Docs", :missing_chunk}, :names), do: {:docs, :missing_chunk}

  defp to_elixir_data({~c"Docs", data}, :names), do: {:docs, :erlang.binary_to_term(data)}

  defp to_elixir_data({~c"ExCk", :missing_chunk}, :names), do: {:elixir_checker, :missing_chunk}

  defp to_elixir_data({~c"ExCk", data}, :names),
    do: {:elixir_checker, :erlang.binary_to_term(data)}

  defp to_elixir_data(item, _type), do: item

  defp path(module) when is_atom(module) do
    case :code.which(module) do
      [] -> {:error, :non_existing}
      [_ | _] = path -> {:ok, path}
      error -> {:error, error}
    end
  end

  defp beam(input) when is_atom(input), do: path(input)
  defp beam({:module, module, binary, _context}) when is_atom(module), do: {:ok, binary}
  defp beam(input) when is_list(input), do: chardata(input)
  defp beam(input) when is_binary(input), do: {:ok, input}
  defp beam(_input), do: {:error, :invalid_input}

  defp chardata(input) do
    _string = IO.chardata_to_string(input)
    {:ok, input}
  rescue
    _error -> {:error, :invalid_input}
  end
end

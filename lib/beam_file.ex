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

  @type input :: path() | module() | binary() | {:module, atom(), binary(), any()}

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
    'Abst',
    'AtU8',
    'Attr',
    'CInf',
    'Dbgi',
    'Docs',
    'ExCk',
    'ExpT',
    'ImpT',
    'LocT'
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

  @doc """
  Returns the `:abstract_code` chunk.

  ## Examples

      iex> BeamFile.abstract_code(BeamFile.Example)
      {
        :ok,
        [
          {:attribute, 1, :file, {'test/fixtures/example.ex', 1}},
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
          {:function, 2, :hello, 0, [{:clause, 2, [], [], [{:atom, 2, :world}]}]}
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
      iex> Map.get(chunks, :docs)
      {:docs_v1, 1, :elixir, "text/markdown", :none, %{},
       [{{:function, :hello, 0}, 2, ["hello()"], :none, %{}}]}

      iex> {:ok, chunks} = BeamFile.all_chunks(BeamFile.Example, :ids)
      iex> chunks |> Map.keys() |> Enum.sort()
      ['Abst', 'AtU8', 'Attr', 'CInf', 'Dbgi', 'Docs', 'ExCk', 'ExpT', 'ImpT', 'LocT']
      iex> chunks |> Map.get('Docs') |> is_binary()
      true
  """
  @spec all_chunks(input(), type :: :names | :ids) :: {:ok, map()} | {:error, any()}
  def all_chunks(input, type \\ :names)

  def all_chunks({:module, _name, bin, _context}, type), do: all_chunks(bin, type)

  def all_chunks(input, type) when is_atom(input) and type in [:ids, :names] do
    with {:ok, path} <- path(input) do
      all_chunks(path, type)
    end
  end

  def all_chunks(input, type) when type in [:ids, :names] do
    chunks =
      case type do
        :names -> @chunk_names
        :ids -> @chunk_ids
      end

    fetch_chunks(input, chunks, type)
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
  def byte_code({:module, _name, bin, _context}), do: byte_code(bin)

  def byte_code(input) when is_atom(input) do
    with {:ok, path} <- path(input), do: byte_code(path)
  end

  def byte_code(input) when is_list(input) or is_binary(input) do
    with {:ok, data} <- read(input) do
      case :beam_disasm.file(data) do
        {:error, :beam_lib, reason} -> {:error, reason}
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

      iex> {:ok, chunk} = BeamFile.chunk(BeamFile.Example, 'Dbgi')
      iex> is_binary(chunk)
      true
  """
  @spec chunk(input(), chunk_ref()) :: {:ok, term()} | {:error, any()}
  def chunk({:module, _name, bin, _context}, chunk), do: chunk(bin, chunk)

  def chunk(input, chunk)
      when is_atom(input) and (chunk in @chunk_ids or chunk in @chunk_names) do
    with {:ok, path} <- path(input), do: chunk(path, chunk)
  end

  def chunk(input, chunk)
      when (is_list(input) or is_binary(input)) and
             (chunk in @chunk_ids or chunk in @chunk_names) do
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
      iex> Map.get(info, :definitions)
      [{{:hello, 0}, :def, [line: 2], [{[line: 2], [], [], :world}]}]
      iex> Map.get(info, :relative_file)
      "test/fixtures/example.ex"

  """
  @spec debug_info(input()) :: {:ok, term()} | {:error, any}
  def debug_info({:module, _name, bin, _context}), do: debug_info(bin)

  def debug_info(input) when is_atom(input) do
    with {:ok, path} <- path(input) do
      debug_info(path)
    end
  end

  def debug_info(input) when is_list(input) or is_binary(input) do
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

  ## Examples

      iex> BeamFile.docs(BeamFile.Example)
      {:ok, {:none, %{}, [{{:function, :hello, 0}, 2, ["hello()"], :none, %{}}]}}
  """
  @spec docs(input()) :: {:ok, term()} | {:error, any}
  def docs({:module, _name, bin, _context}), do: docs(bin)

  def docs(input) when is_atom(input) do
    with {:ok, path} <- path(input) do
      docs(path)
    end
  end

  def docs(input) when is_list(input) or is_binary(input) do
    with {:ok, {:docs_v1, _, :elixir, "text/markdown", doc, meta, docs}} <- chunk(input, :docs) do
      {:ok, {doc, meta, docs}}
    end
  end

  @doc """
  Same as `docs/1` but raises `BeamFile.Error`
  """
  @spec docs!(input()) :: term()
  def docs!(input) do
    case docs(input) do
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
  def elixir_code(input, opts \\ [])

  def elixir_code({:module, _name, bin, _context}, opts), do: elixir_code(bin, opts)

  def elixir_code(input, opts) when is_atom(input) do
    with {:ok, path} <- path(input) do
      elixir_code(path, opts)
    end
  end

  def elixir_code(input, opts) when is_list(input) or is_binary(input) do
    with {:ok, debug_info} <- debug_info(input),
         {:ok, docs} <- docs(input, opts) do
      code =
        if docs do
          DebugInfo.code(debug_info, docs)
        else
          debug_info |> DebugInfo.ast() |> Macro.to_string()
        end

      {:ok, code}
    end
  end

  defp docs(input, opts) do
    if Keyword.get(opts, :docs, false), do: docs(input), else: {:ok, nil}
  end

  @doc """
  Same as `elixir_code/1` but raises `BeamFile.Error`
  """
  @spec elixir_code!(input(), opts :: keyword()) :: String.t()
  def elixir_code!(input, opts \\ [])

  def elixir_code!({:module, _name, bin, _context}, opts), do: elixir_code!(bin, opts)

  def elixir_code!(input, opts) do
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
  def erl_code({:module, _name, bin, _context}) do
    erl_code(bin)
  end

  def erl_code(input) when is_atom(input) do
    with {:ok, path} <- path(input) do
      erl_code(path)
    end
  end

  def erl_code(input) when is_list(input) or is_binary(input) do
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
  Returns the binary for the given BEAM file.
  """
  @spec read(Path.t() | path() | module()) ::
          {:ok, binary()}
          | {:error, File.posix()}
          | {:error, :non_existing | :preloaded | :cover_compiled}
  def read(input) when is_binary(input), do: {:ok, input}

  def read(input) when is_list(input) do
    input |> List.to_string() |> File.read()
  end

  def read(input) when is_atom(input) do
    with {:ok, path} <- which(input), do: path |> String.to_charlist() |> read()
  end

  @doc """
  Same as `read/1` but raises `BeamFile.Error`
  """
  @spec read!(Path.t() | path() | module()) :: binary()
  def read!(input) do
    case read(input) do
      {:ok, binary} ->
        binary

      {:error, reason} ->
        raise Error, """
        Can not read #{inspect(input, binaries: :as_binaries)}, \
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
        'AtU8',
        'Attr',
        'CInf',
        'Code',
        'Dbgi',
        'Docs',
        'ExCk',
        'ExpT',
        'ImpT',
        'Line',
        'LitT',
        'LocT',
        'StrT',
        'Type'
      ]
  """
  @spec info(input()) :: {:ok, info()} | {:error, reason()}
  def info({:module, _name, bin, _context}), do: info(bin)

  def info(input) when is_atom(input) do
    with {:ok, path} <- path(input), do: info(path)
  end

  def info(input) when is_list(input) do
    case :beam_lib.info(input) do
      {:error, :beam_lib, reason} ->
        {:error, reason}

      info ->
        info = Keyword.put(info, :file, IO.chardata_to_string(input))
        {:ok, info}
    end
  end

  def info(input) when is_binary(input) do
    case :beam_lib.info(input) do
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
    case :code.which(module) do
      [_ | _] = path -> {:ok, IO.chardata_to_string(path)}
      [] -> {:error, :non_existing}
      error -> {:error, error}
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
  defp to_erl_chunk(:docs), do: 'Docs'

  defp to_erl_chunk(:elixir_checker), do: 'ExCk'

  defp to_erl_chunk(chunk), do: chunk

  # For some chunks we need a transformation.
  defp to_elixir_data({'Docs', data}, :names), do: {:docs, :erlang.binary_to_term(data)}

  defp to_elixir_data({'ExCk', data}, :names), do: {:elixir_checker, :erlang.binary_to_term(data)}

  defp to_elixir_data({'Docs', data}, :ids), do: {'Docs', data}

  defp to_elixir_data({'ExCk', data}, :ids), do: {'ExCk', data}

  defp to_elixir_data(item, _type), do: item

  defp path(module) when is_atom(module) do
    case :code.which(module) do
      [] -> {:error, :non_existing}
      [_ | _] = path -> {:ok, path}
      error -> {:error, error}
    end
  end
end

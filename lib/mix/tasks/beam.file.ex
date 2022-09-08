defmodule Mix.Tasks.Beam.File do
  @shortdoc "Prints the decompiled source for a module."

  @moduledoc """
  #{@shortdoc}

  ```shell
  mix beam.file module switch
  ```
  The argument `module` specifies the `module` to decompile. The `switch` can be
  one of `--elixir`, `--erlang`, or `--bytte-code`.

  Decompiling with `--elixir` returns the expanded Elixir code.
  """

  use Mix.Task

  @opts strict: [elixir: :boolean, erlang: :boolean, byte_code: :boolean]
  @error ~s|Could not invoke task "beam.file":|

  @impl Mix.Task
  def run(opts) do
    opts
    |> OptionParser.parse!(@opts)
    |> validate()
    |> output()
  end

  defp output({[{type, true}], [module]}) do
    Mix.Task.run("compile")

    module = Module.concat([module])

    module
    |> code(type)
    |> check()
    |> IO.puts()
  end

  defp check({:ok, code}), do: code

  defp check({:error, error}) do
    Mix.raise("BeamFileError: #{to_string(error)}")
  end

  defp code(module, :elixir), do: BeamFile.elixir_code(module)

  defp code(module, :erlang), do: BeamFile.erl_code(module)

  defp code(module, :byte_code) do
    with {:ok, byte_code} <- BeamFile.byte_code(module) do
      {:ok, inspect(byte_code, pretty: true, limit: :infinity)}
    end
  end

  defp validate({[], _args}) do
    Mix.raise("""
    #{@error}
    Missing one of the switches `--elixir`, `--erlang`, or `--byte-code`.
    """)
  end

  defp validate({_opts, []}) do
    Mix.raise("""
    #{@error}
    Missing a moudle name.
    """)
  end

  defp validate({opts, args}) when length(opts) > 1 or length(args) > 1 do
    Mix.raise("""
    #{@error}
    Too many arguments.
    """)
  end

  defp validate(opts), do: opts
end

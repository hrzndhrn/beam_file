# Some test modules will be compiled multiple times.
Code.put_compiler_option(:ignore_module_conflict, true)

# Compile test modules here to prevent them from being compiled in coverage mode.
"test/**/*.ex"
|> Path.wildcard()
|> Kernel.ParallelCompiler.compile_to_path("_build/test/lib/beam_file/ebin")

defmodule TestSupport do
  def system_version do
    {:ok, version} = Version.parse(System.version())

    cond do
      Version.match?(version, "~> 1.14") -> "1.14.3"
      Version.match?(version, "~> 1.13") -> "1.13.4"
      Version.match?(version, "~> 1.12") -> "1.12.3"
      Version.match?(version, "~> 1.11") -> "1.11.4"
    end
  end

  def fixture_version(file) do
    "test/fixtures/#{system_version()}/#{file}/" |> Code.eval_file() |> elem(0)
  end

  def version?(require) do
    {:ok, version} = Version.parse(System.version())
    Version.match?(version, require)
  end
end

ExUnit.start()

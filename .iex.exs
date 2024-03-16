if function_exported?(BeamFile, :info, 1) do
  defmodule Dev do
    def compile_fixtures do
      "test/**/*.ex"
      |> Path.wildcard()
      |> Kernel.ParallelCompiler.compile_to_path("_build/test/lib/beam_file/ebin")
    end
  end

  Dev.compile_fixtures()
end

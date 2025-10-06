# Some test modules will be compiled multiple times.
Code.put_compiler_option(:ignore_module_conflict, true)

# Compile test modules here to prevent them from being compiled in coverage mode.
"test/**/*.ex"
|> Path.wildcard()
|> Kernel.ParallelCompiler.compile_to_path("_build/test/lib/beam_file/ebin",
  return_diagnostics: true
)

ExUnit.start()

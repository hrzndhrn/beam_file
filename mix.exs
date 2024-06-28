defmodule BeamFile.MixProject do
  use Mix.Project

  def project do
    [
      app: :beam_file,
      version: "0.6.1",
      elixir: "~> 1.13",
      description: "An interface to the BEAM file format and a decompiler",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      dialyzer: dialyzer(),
      package: package(),
      docs: docs(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :syntax_tools]
    ]
  end

  defp docs do
    [
      main: "BeamFile",
      formatters: ["html"]
    ]
  end

  defp preferred_cli_env do
    [
      carp: :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.html": :test,
      "coveralls.github": :test
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :syntax_tools],
      plt_file: {:no_warn, "test/support/plts/dialyzer.plt"},
      flags: [:unmatched_returns]
    ]
  end

  defp aliases do
    [
      carp: "test --seed 0 --max-failures 1"
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:recode, "~> 0.7", only: [:dev, :test]}
    ]
  end

  defp package do
    [
      maintainers: ["Marcus Kruse"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/hrzndhrn/beam_file"}
    ]
  end
end

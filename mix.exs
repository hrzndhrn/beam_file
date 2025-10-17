defmodule BeamFile.MixProject do
  use Mix.Project

  def project do
    [
      app: :beam_file,
      version: "0.6.3",
      elixir: "~> 1.13",
      description: "An interface to the BEAM file format and a decompiler",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      dialyzer: dialyzer(),
      package: package(),
      docs: docs(),
      aliases: aliases(),
      test_ignore_filters: ["test/test_support.ex", ~r/.*fixtures.*/]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :syntax_tools]
    ]
  end

  def cli do
    [
      preferred_envs: [
        carp: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.github": :test
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/test_support.ex"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      main: "BeamFile",
      formatters: ["html"]
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
      carp: "test --seed 0 --max-failures 1 --trace"
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

defmodule BeamFile.MixProject do
  use Mix.Project

  def project do
    [
      app: :beam_file,
      version: "0.1.0",
      elixir: "~> 1.11",
      description: "An interface to the BEAM file format and a decompiler",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(),
      dialyzer: dialyzer(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :syntax_tools]
    ]
  end

  defp elixirc_paths do
    if Mix.env() == :test do
      ["lib", "test/fixtures"]
    else
      ["lib"]
    end
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :syntax_tools, :beam_lib],
      plt_file: {:no_warn, "test/support/plts/dialyzer.plt"},
      flags: [:unmatched_returns]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Marcus Kruse"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/hrzndhrn/time_zone_info"}
    ]
  end
end

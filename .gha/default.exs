defmodule GitHubActions.Default do
  use GitHubActions.Workflow

  def workflow do
    [
      name: "CI",
      env: [
        GITHUB_TOKEN: ~e[secrets.GITHUB_TOKEN]
      ],
      on: ~w(pull_request push),
      jobs: [
        linux: job(:linux),
        windows: job(:windows),
        macos: job(:macos)
      ]
    ]
  end

  defp elixir_version do
    elixir = Config.get(:elixir)
    if elixir, do: "~> #{Version.minor(elixir)}", else: Project.elixir()
  end

  defp otp_version, do: "> 21.0.0"

  defp matrix do
    Versions.matrix(
      elixir: elixir_version(),
      otp: otp_version()
    )
  end

  defp job(:linux = os) do
    job(os,
      name: """
      Test on #{Config.get([os, :name])} (\
      Elixir #{~e[matrix.elixir]}, \
      OTP #{~e[matrix.otp]})\
      """,
      runs_on: Config.get([os, :runs_on]),
      strategy: [matrix: matrix()],
      steps: [
        checkout(),
        setup_elixir(os),
        restore(:deps),
        restore(:_build),
        restore(:dialyxir),
        get_deps(),
        compile_deps(os),
        compile(os),
        check_unused_deps(),
        check_code_format(),
        lint_code(),
        run_tests(os),
        run_coverage(os),
        dialyxir()
      ]
    )
  end

  defp job(:windows = os) do
    job(os,
      name: "Test on #{Config.get([os, :name])}",
      runs_on: Config.get([os, :runs_on]),
      steps: [
        checkout(),
        setup_elixir(os),
        get_deps(),
        compile_deps(os),
        compile(os),
        run_tests(os),
        run_coverage(os)
      ]
    )
  end

  defp job(:macos = os) do
    job(os,
      name: "Test on #{Config.get([os, :name])}",
      runs_on: Config.get([os, :runs_on]),
      steps: [
        checkout(),
        setup_elixir(os),
        install_hex(),
        install_rebar(),
        restore(:deps),
        restore(:_build),
        get_deps(),
        compile_deps(os),
        compile(os),
        run_tests(os),
        run_coverage(os)
      ]
    )
  end

  defp job(os, config) do
    case member?(:jobs, os) do
      true -> config
      false -> :skip
    end
  end

  defp checkout do
    [
      name: "Checkout",
      uses: "actions/checkout@v4"
    ]
  end

  defp setup_elixir(:linux) do
    [
      name: "Setup Elixir",
      id: "setup-beam",
      uses: "erlef/setup-beam@v1",
      with: [
        elixir_version: ~e[matrix.elixir],
        otp_version: ~e[matrix.otp]
      ]
    ]
  end

  defp setup_elixir(:macos) do
    [
      name: "Setup Elixir",
      id: "setup-beam",
      run: "brew install elixir"
    ]
  end

  defp setup_elixir(:windows) do
    [
      name: "Setup Elixir",
      id: "setup-beam",
      uses: "erlef/setup-beam@v1",
      with: [
        elixir_version: Versions.latest(:elixir),
        otp_version: Versions.latest(:otp)
      ]
    ]
  end

  defp install_hex do
    [
      name: "Install hex",
      run: mix(:local, :hex, force: true)
    ]
  end

  defp install_rebar do
    [
      name: "Install rebar",
      run: mix(:local, :rebar, force: true)
    ]
  end

  defp restore(:dialyxir) do
    case Project.has_dep?(:dialyxir) and Config.get([:steps, :dialyxir]) do
      false ->
        :skip

      true ->
        case Project.fetch([:dialyzer, :plt_file]) do
          :error ->
            :skip

          {:ok, {_, file}} ->
            file |> Path.dirname() |> restore(if: latest_version(true))
        end
    end
  end

  defp restore(path, opts \\ []) do
    case Config.fetch!([:steps, :refresh]) do
      false ->
        :skip

      true ->
        {opt_if, opts} = Keyword.pop(opts, :if)
        opt_if = if opt_if, do: [if: opt_if], else: []

        Keyword.merge(
          [name: "Restore #{path}"] ++
            opt_if ++
            [
              uses: "actions/cache@v4",
              with: [
                path: path,
                key: key(path)
              ]
            ],
          opts
        )
    end
  end

  defp get_deps do
    [
      name: "Get dependencies",
      run: mix(:deps, :get)
    ]
  end

  defp compile_deps(os) do
    [
      name: "Compile dependencies",
      run: mix(:deps, :compile, env: :test, os: os)
    ]
  end

  defp compile(os) do
    [
      name: "Compile project",
      run: mix(:compile, warnings_as_errors: true, env: :test, os: os)
    ]
  end

  defp check_unused_deps do
    case Config.get(:check_unused_deps, true) do
      false ->
        :skip

      true ->
        [
          name: "Check unused dependencies",
          if: latest_version(true),
          run: mix(:deps, :unlock, check_unused: true)
        ]
    end
  end

  defp check_code_format do
    case Config.get(:check_code_format, true) do
      false ->
        :skip

      true ->
        [
          name: "Check code format",
          if: latest_version(true),
          run: mix(:format, check_formatted: true)
        ]
    end
  end

  defp lint_code do
    case Project.has_dep?(:credo) do
      false ->
        :skip

      true ->
        [
          name: "Lint code",
          if: latest_version(true),
          run: mix(:credo, strict: true)
        ]
    end
  end

  defp run_tests(:windows) do
    [
      name: "Run tests",
      run: mix(:test)
    ]
  end

  defp run_tests(_nix) do
    case Project.has_dep?(:excoveralls) do
      true ->
        [
          name: "Run tests",
          if: latest_version(false),
          run: mix(:test)
        ]

      false ->
        [
          name: "Run tests",
          run: mix(:test)
        ]
    end
  end

  defp run_coverage(:windows), do: :skip

  defp run_coverage(_nix) do
    case Project.has_dep?(:excoveralls) do
      true ->
        [
          name: "Run tests with coverage",
          if: latest_version(true),
          run: mix(:coveralls, Config.get([:steps, :coveralls]))
        ]

      false ->
        :skip
    end
  end

  defp dialyxir do
    case Project.has_dep?(:dialyxir) do
      false ->
        :skip

      true ->
        [
          name: "Static code analysis",
          if: latest_version(true),
          run: mix(:dialyzer, force_check: true, format: "github")
        ]
    end
  end

  defp key(key) do
    os = ~e[runner.os]
    elixir = ~e[matrix.elixir]
    otp = ~e[matrix.otp]
    setup_beam_version = ~e{steps.setup-beam.outputs.setup-beam-version}
    lock = ~e[hashFiles(format('{0}{1}', github.workspace, '/mix.lock'))]
    "#{key}-#{os}-#{elixir}-#{otp}-#{lock}-#{setup_beam_version}"
  end

  defp latest_version(true) do
    ~e"""
    matrix.elixir == '#{Versions.latest(:elixir)}' && \
    matrix.otp == '#{Versions.latest(:otp)}'\
    """
  end

  defp latest_version(false) do
    ~e"""
    !(matrix.elixir == '#{Versions.latest(:elixir)}' && \
    matrix.otp == '#{Versions.latest(:otp)}')\
    """
  end

  defp member?(key, value), do: key |> Config.get() |> Enum.member?(value)
end

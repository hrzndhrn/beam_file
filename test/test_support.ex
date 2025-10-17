defmodule TestSupport do
  @moduledoc false

  @latest_otp_release 28
  @latest_elixir_version "1.19.0"

  def version?(:latest) do
    if Version.compare(@latest_elixir_version, system_version()) == :lt do
      raise "@latest_elixir_version is lower than system version (#{inspect(system_version())})"
    else
      version?(@latest_elixir_version)
    end
  end

  def version?(require) do
    Version.match?(system_version(), require)
  end

  def version?(elixir_version, otp_release) do
    version?(elixir_version) and otp_release?(otp_release)
  end

  def otp_release?(:latest) do
    if @latest_otp_release < otp_release() do
      raise "@latest_otp_release is lower than otp release"
    else
      otp_release?(@latest_otp_release)
    end
  end

  def otp_release?(release) when is_integer(release) do
    otp_release() == release
  end

  def otp_release?(releases) when is_list(releases) do
    Enum.any?(releases, &otp_release?/1)
  end

  def fixture(file, opts \\ []) do
    path = "test/fixtures/#{system_version()}/#{file}"

    if Keyword.get(opts, :eval, false) do
      path |> Code.eval_file() |> elem(0)
    else
      File.read!(path)
    end
  end

  defp otp_release do
    :erlang.list_to_integer(:erlang.system_info(:otp_release))
  end

  defp system_version do
    with {:ok, version} <- Version.parse(System.version()), do: version
  end
end

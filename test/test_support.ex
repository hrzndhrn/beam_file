defmodule TestSupport do
  @moduledoc false

  @latest_otp_release 26
  @latest_elixir_version "1.16.2"

  def version?(:latest) do
    version?(@latest_elixir_version)
  end

  def version?(require) do
    Version.match?(system_version(), require)
  end

  def version?(elixir_version, otp_release) do
    version?(elixir_version) and otp_release?(otp_release)
  end

  def otp_release?(:latest) do
    otp_release?(@latest_otp_release)
  end

  def otp_release?(release) when is_integer(release) do
    :erlang.list_to_integer(:erlang.system_info(:otp_release)) == release
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

  defp system_version do
    with {:ok, version} <- Version.parse(System.version()), do: version
  end
end

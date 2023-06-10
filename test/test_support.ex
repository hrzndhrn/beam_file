defmodule TestSupport do
  @moduledoc false

  def system_version do
    {:ok, version} = Version.parse(System.version())

    cond do
      Version.match?(version, "~> 1.14") -> "1.14.5"
      Version.match?(version, "~> 1.13") -> "1.13.4"
      Version.match?(version, "~> 1.12") -> "1.12.3"
      Version.match?(version, "~> 1.11") -> "1.11.4"
    end
  end

  def fixture_version(file) do
    path = "test/fixtures/#{system_version()}/#{file}"

    if Path.extname(file) == ".exs" do
      path |> Code.eval_file() |> elem(0)
    else
      File.read!(path)
    end
  end

  def version?(require) do
    {:ok, version} = Version.parse(System.version())
    Version.match?(version, require)
  end

  def otp_release?(release) do
    :erlang.list_to_integer(:erlang.system_info(:otp_release)) == release
  end
end

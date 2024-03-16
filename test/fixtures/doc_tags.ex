defmodule DocTags do
  @moduledoc """
  moduledoc-content
  """
  @moduledoc since: "1.1.0"

  @typedoc "type-doc"
  @typedoc since: "1.2.0"
  @type alpha :: :alpha

  def alpha, do: :alpha

  @doc since: "1.2.0"
  def bravo, do: :bravo

  @doc since: "1.3.0"
  def charlie, do: :charlie

  @doc since: "1.3.0"
  @deprecated "use bravo/0 instead"
  def delta, do: :delta

  @doc false
  @doc since: "1.3.0"
  @deprecated "use bravo/0 instead"
  def echo, do: :echo

  @doc since: "1.3.0"
  @doc deprecated: "use bravo/0 instead"
  def foxtrot, do: :foxtrot
end

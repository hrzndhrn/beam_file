defmodule BeamFile.Error do
  @moduledoc """
  An exception that is raised when a `BeamFile` operation fails.
  """

  defexception [:message]
end

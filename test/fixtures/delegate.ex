defmodule Delegate do
  defdelegate now(time_zone), to: DateTime
end

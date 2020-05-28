defmodule Elixir.Delegate do
  def now(time_zone) do
    DateTime.now(time_zone)
  end
end

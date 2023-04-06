defmodule Elixir.Bodies do
  def call([]) do
    :empty
  end

  def call(_) do
    :full
  end
end

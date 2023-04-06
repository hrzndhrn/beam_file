defmodule Bodies do
  def call([]), do: :empty
  def call(_), do: :full
end

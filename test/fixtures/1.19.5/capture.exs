defmodule Elixir.Capture do
  def fun do
    fn capture3, capture4 -> :erlang.+(:erlang.*(capture3, capture4), capture3) end
  end

  def double do
    fn capture5 -> :erlang.+(capture5, capture5) end
  end
end

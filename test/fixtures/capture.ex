defmodule Capture do
  def fun do
    &(&1 * &2 + &1)
  end

  def double do
    &(&1 + &1)
  end
end

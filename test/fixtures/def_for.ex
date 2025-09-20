defmodule DefFor do
  def for do
    :for
  end

  def for(x) do
    {x}
  end

  def for(x, y) do
    {x, y}
  end

  def foo(x, y) do
    {x, y}
  end

  def for(x, y, z), do: {x, y, z}
end

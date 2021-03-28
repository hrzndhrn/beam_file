defmodule Default do
  def go(x \\ 42_000), do: x

  def gogo(a, x \\ 666_000, y \\ 1_000), do: a + x + y
end

defmodule Say do
  def hello(name \\ "World"), do: name |> format() |> puts()

  def format(name), do: "Hello, #{name}!"

  defdelegate puts(item), to: IO
end

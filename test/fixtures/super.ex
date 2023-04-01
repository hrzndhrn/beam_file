defmodule DefaultMod do
  defmacro __using__(_opts) do
    quote do
      def test(x, y) do
        x + y
      end

      def foo(x), do: x

      defoverridable test: 2, foo: 1
    end
  end
end

defmodule InheritMod do
  use DefaultMod

  def test(x, y) do
    x * y + super(x, y)
  end
end

defmodule NoneZero do
  def call(x)
      when x > 0
      when x < 0 do
    x
  end
end

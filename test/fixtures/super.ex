defmodule DefaultMod do
  defmacro __using__(_opts) do
    quote do
      def bar(x, y) do
        x + y
      end

      def foo(x), do: x

      defoverridable bar: 2, foo: 1
    end
  end
end

defmodule InheritMod do
  use DefaultMod

  def bar(x, y) do
    x * y + super(x, y)
  end
end

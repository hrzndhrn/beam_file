defmodule Elixir.DefaultMod do
  defmacro __using__(_opts) do
    {:__block__, [],
     [
       {:def, [context: DefaultMod, imports: [{1, Kernel}, {2, Kernel}]],
        [
          {:bar, [context: DefaultMod], [{:x, [], DefaultMod}, {:y, [], DefaultMod}]},
          [
            do:
              {:+, [context: DefaultMod, imports: [{1, Kernel}, {2, Kernel}]],
               [{:x, [], DefaultMod}, {:y, [], DefaultMod}]}
          ]
        ]},
       {:def, [context: DefaultMod, imports: [{1, Kernel}, {2, Kernel}]],
        [{:foo, [context: DefaultMod], [{:x, [], DefaultMod}]}, [do: {:x, [], DefaultMod}]]},
       {:defoverridable, [context: DefaultMod, imports: [{1, Kernel}]], [[bar: 2, foo: 1]]}
     ]}
  end
end

defmodule Elixir.InheritMod do
  defp unquote(:"bar (overridable 1)")(x, y) do
    :erlang.+(x, y)
  end

  def foo(x) do
    x
  end

  def bar(x, y) do
    :erlang.+(:erlang.*(x, y), unquote(:"bar (overridable 1)")(x, y))
  end
end

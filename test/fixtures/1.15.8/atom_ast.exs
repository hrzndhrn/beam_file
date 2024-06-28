{
  :defmodule,
  [context: Elixir, import: Kernel],
  [
    {:__aliases__, [alias: false], [Atom]},
    [
      do: {
        :__block__,
        [],
        [
          {
            :def,
            [line: 2],
            [
              {:from, [], [{:string, [version: 0, line: 2], nil}]},
              [
                do: {
                  {:., [line: 3], [:erlang, :binary_to_atom]},
                  [line: 3],
                  [{:string, [version: 0, line: 3], nil}, :utf8]
                }
              ]
            ]
          }
        ]
      }
    ]
  ]
}

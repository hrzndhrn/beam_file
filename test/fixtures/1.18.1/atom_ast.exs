{:defmodule, [context: Elixir, import: Kernel],
 [
   {:__aliases__, [alias: false], [Atom]},
   [
     do:
       {:__block__, [],
        [
          {:def, [line: 2, column: 7],
           [
             {:from, [], [{:string, [version: 0, line: 2, column: 12], nil}]},
             [
               do:
                 {{:., [line: 3, column: 11], [:erlang, :binary_to_atom]}, [line: 3, column: 12],
                  [{:string, [version: 0, line: 3, column: 20], nil}]}
             ]
           ]}
        ]}
   ]
 ]}

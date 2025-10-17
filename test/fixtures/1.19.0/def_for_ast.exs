{:defmodule, [context: Elixir, import: Kernel],
 [
   {:__aliases__, [alias: false], [DefFor]},
   [
     do:
       {:__block__, [],
        [
          {:def, [line: 2, column: 7], [{:for, [], Elixir}, [do: :for]]},
          {:def, [line: 6, column: 7],
           [
             {:for, [], [{:x, [version: 0, line: 6, column: 11], nil}]},
             [
               do: {:{}, [line: 7, column: 5], [{:x, [version: 0, line: 7, column: 6], nil}]}
             ]
           ]},
          {:def, [line: 10, column: 7],
           [
             {:for, [],
              [
                {:x, [version: 0, line: 10, column: 11], nil},
                {:y, [version: 1, line: 10, column: 14], nil}
              ]},
             [
               do:
                 {{:x, [version: 0, line: 11, column: 6], nil},
                  {:y, [version: 1, line: 11, column: 9], nil}}
             ]
           ]},
          {:def, [line: 14, column: 7],
           [
             {:foo, [],
              [
                {:x, [version: 0, line: 14, column: 11], nil},
                {:y, [version: 1, line: 14, column: 14], nil}
              ]},
             [
               do:
                 {{:x, [version: 0, line: 15, column: 6], nil},
                  {:y, [version: 1, line: 15, column: 9], nil}}
             ]
           ]},
          {:def, [line: 18, column: 7],
           [
             {:for, [],
              [
                {:x, [version: 0, line: 18, column: 11], nil},
                {:y, [version: 1, line: 18, column: 14], nil},
                {:z, [version: 2, line: 18, column: 17], nil}
              ]},
             [
               do:
                 {:{}, [line: 18, column: 25],
                  [
                    {:x, [version: 0, line: 18, column: 26], nil},
                    {:y, [version: 1, line: 18, column: 29], nil},
                    {:z, [version: 2, line: 18, column: 32], nil}
                  ]}
             ]
           ]}
        ]}
   ]
 ]}

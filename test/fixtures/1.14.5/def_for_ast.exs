{:defmodule, [context: Elixir, import: Kernel],
 [
   {:__aliases__, [alias: false], [DefFor]},
   [
     do:
       {:__block__, [],
        [
          {:def, [line: 2], [{:for, [], Elixir}, [do: :for]]},
          {:def, [line: 6],
           [
             {:for, [], [{:x, [version: 0, line: 6], nil}]},
             [
               do: {:{}, [line: 7], [{:x, [version: 0, line: 7], nil}]}
             ]
           ]},
          {:def, [line: 10],
           [
             {:for, [],
              [
                {:x, [version: 0, line: 10], nil},
                {:y, [version: 1, line: 10], nil}
              ]},
             [
               do: {{:x, [version: 0, line: 11], nil}, {:y, [version: 1, line: 11], nil}}
             ]
           ]},
          {:def, [line: 14],
           [
             {:foo, [],
              [
                {:x, [version: 0, line: 14], nil},
                {:y, [version: 1, line: 14], nil}
              ]},
             [
               do: {{:x, [version: 0, line: 15], nil}, {:y, [version: 1, line: 15], nil}}
             ]
           ]},
          {:def, [line: 18],
           [
             {:for, [],
              [
                {:x, [version: 0, line: 18], nil},
                {:y, [version: 1, line: 18], nil},
                {:z, [version: 2, line: 18], nil}
              ]},
             [
               do:
                 {:{}, [line: 18],
                  [
                    {:x, [version: 0, line: 18], nil},
                    {:y, [version: 1, line: 18], nil},
                    {:z, [version: 2, line: 18], nil}
                  ]}
             ]
           ]}
        ]}
   ]
 ]}

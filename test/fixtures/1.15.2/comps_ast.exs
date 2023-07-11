{:defmodule, [context: Elixir, import: Kernel],
 [
   {:__aliases__, [alias: false], [Comps]},
   [
     do:
       {:__block__, [],
        [
          {:def, [line: 2],
           [
             {:one, [], Elixir},
             [
               do:
                 {:for, [line: 3],
                  [
                    {:<-, [line: 3], [{:n, [version: 0, line: 3], nil}, [1, 2, 3]]},
                    [
                      into: [],
                      do:
                        {{:., [line: 3], [:erlang, :*]}, [line: 3],
                         [
                           {:n, [version: 0, line: 3], nil},
                           {:n, [version: 0, line: 3], nil}
                         ]}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 6],
           [
             {:two, [], Elixir},
             [
               do:
                 {:for, [line: 7],
                  [
                    {:<-, [line: 7], [{:n, [version: 0, line: 7], nil}, [1, 2, 3]]},
                    [
                      into: [],
                      do:
                        {{:., [line: 7], [:erlang, :*]}, [line: 7],
                         [
                           {:n, [version: 0, line: 7], nil},
                           {:n, [version: 0, line: 7], nil}
                         ]}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 10],
           [
             {:three, [], Elixir},
             [
               do:
                 {:for, [line: 11],
                  [
                    {:<-, [line: 11], [{:n, [version: 0, line: 11], nil}, [1, 2, 3]]},
                    [
                      into: {:%{}, [line: 11], []},
                      do:
                        {{:n, [version: 0, line: 11], nil},
                         {{:., [line: 11], [:erlang, :*]}, [line: 11],
                          [
                            {:n, [version: 0, line: 11], nil},
                            {:n, [version: 0, line: 11], nil}
                          ]}}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 14],
           [
             {:four, [], Elixir},
             [
               do:
                 {:for, [line: 15],
                  [
                    {:<-, [line: 15], [{:i, [version: 0, line: 15], nil}, [1, 2, 3]]},
                    {:<-, [line: 16], [{:n, [version: 1, line: 16], nil}, [1, 2, 3]]},
                    [
                      into: {:%{}, [line: 17], []},
                      do: {{:i, [version: 0, line: 18], nil}, {:n, [version: 1, line: 18], nil}}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 21],
           [
             {:five, [], Elixir},
             [
               do:
                 {:for, [line: 22],
                  [
                    {:<<>>, [line: 22],
                     [
                       {:<-, [line: 22],
                        [
                          {:<<>>, [alignment: 0, line: 22],
                           [
                             {:"::", [inferred_bitstring_spec: true, line: 22],
                              [
                                {:x, [version: 0, line: 22], nil},
                                {:integer, [line: 22], nil}
                              ]}
                           ]},
                          "abcabc"
                        ]}
                     ]},
                    [
                      uniq: true,
                      into: "",
                      do:
                        {:<<>>, [alignment: 0, line: 22],
                         [
                           {:"::", [inferred_bitstring_spec: true, line: 22],
                            [
                              {{:., [line: 22], [:erlang, :-]}, [line: 22],
                               [{:x, [version: 0, line: 22], nil}, 32]},
                              {:integer, [line: 22], nil}
                            ]}
                         ]}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 25],
           [
             {:six, [], Elixir},
             [
               do:
                 {:for, [line: 26],
                  [
                    {:<<>>, [line: 26],
                     [
                       {:<-, [line: 26],
                        [
                          {:<<>>, [alignment: 0, line: 26],
                           [
                             {:"::", [inferred_bitstring_spec: true, line: 26],
                              [
                                {:x, [version: 0, line: 26], nil},
                                {:integer, [line: 26], nil}
                              ]}
                           ]},
                          "AbCabCABc"
                        ]}
                     ]},
                    {{:., [line: 26], [:erlang, :andalso]}, [line: 26],
                     [
                       {{:., [line: 26], [:erlang, :is_integer]}, [line: 26],
                        [{:x, [version: 0, line: 26], nil}]},
                       {{:., [line: 26], [:erlang, :andalso]}, [line: 26],
                        [
                          {{:., [line: 26], [:erlang, :>=]}, [line: 26],
                           [{:x, [version: 0, line: 26], nil}, 97]},
                          {{:., [line: 26], [:erlang, :"=<"]}, [line: 26],
                           [{:x, [version: 0, line: 26], nil}, 122]}
                        ]}
                     ]},
                    [
                      reduce: {:%{}, [line: 26], []},
                      do: [
                        {:->, [line: 27],
                         [
                           [{:acc, [version: 1, line: 27], nil}],
                           {{:., [line: 27], [Map, :update]}, [line: 27],
                            [
                              {:acc, [version: 1, line: 27], nil},
                              {:<<>>, [alignment: 0, line: 27],
                               [
                                 {:"::", [inferred_bitstring_spec: true, line: 27],
                                  [
                                    {:x, [version: 0, line: 27], nil},
                                    {:integer, [line: 27], nil}
                                  ]}
                               ]},
                              1,
                              {:fn, [line: 27],
                               [
                                 {:->, [line: 27],
                                  [
                                    [{:x1, [version: 2], :elixir_fn}],
                                    {{:., [line: 27], [:erlang, :+]}, [line: 27],
                                     [{:x1, [version: 2], :elixir_fn}, 1]}
                                  ]}
                               ]}
                            ]}
                         ]}
                      ]
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 31],
           [
             {:seven, [], Elixir},
             [
               do:
                 {{:., [line: 32], [:erlang, :++]}, [line: 32],
                  [
                    {:for, [line: 32],
                     [
                       {:<-, [line: 32], [{:x, [version: 0, line: 32], nil}, [1, 2]]},
                       [into: [], do: {:x, [version: 0, line: 32], nil}]
                     ]},
                    {:for, [line: 32],
                     [
                       {:<-, [line: 32], [{:y, [version: 1, line: 32], nil}, [3, 4]]},
                       [into: [], do: {:y, [version: 1, line: 32], nil}]
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 35],
           [
             {:eight, [], Elixir},
             [
               do:
                 {{:., [line: 36], [:erlang, :--]}, [line: 36],
                  [
                    {:for, [line: 36],
                     [
                       {:<-, [line: 36], [{:x, [version: 0, line: 36], nil}, [1, 2]]},
                       [into: [], do: {:x, [version: 0, line: 36], nil}]
                     ]},
                    {:for, [line: 36],
                     [
                       {:<-, [line: 36], [{:y, [version: 1, line: 36], nil}, [3, 4]]},
                       [into: [], do: {:y, [version: 1, line: 36], nil}]
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 39],
           [
             {:nine, [], [{:list, [version: 0, line: 39], nil}]},
             [
               do:
                 {{:., [line: 40], [:erlang, :++]}, [line: 40],
                  [
                    {:list, [version: 0, line: 40], nil},
                    {{:., [line: 40], [Enum, :sort]}, [line: 40],
                     [
                       {:for, [line: 40],
                        [
                          {:<-, [line: 40], [{:x, [version: 1, line: 40], nil}, [1, 2]]},
                          [into: [], do: {:x, [version: 1, line: 40], nil}]
                        ]}
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 43],
           [
             {:ten, [], [{:list, [version: 0, line: 43], nil}]},
             [
               do:
                 {{:., [line: 44], [:erlang, :++]}, [line: 44],
                  [
                    {:list, [version: 0, line: 44], nil},
                    {{:., [line: 44], [Enum, :sort]}, [line: 44],
                     [
                       {:for, [line: 44],
                        [
                          {:<-, [line: 44], [{:x, [version: 1, line: 44], nil}, [1, 2]]},
                          [into: [], do: {:x, [version: 1, line: 44], nil}]
                        ]}
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 47],
           [
             {:eleven, [], [{:list, [version: 0, line: 47], nil}]},
             [
               do:
                 {{:., [line: 48], [:erlang, :--]}, [line: 48],
                  [
                    {:list, [version: 0, line: 48], nil},
                    {{:., [line: 48], [Enum, :sort]}, [line: 48],
                     [
                       {:for, [line: 48],
                        [
                          {:<-, [line: 48], [{:x, [version: 1, line: 48], nil}, [1, 2]]},
                          [into: [], do: {:x, [version: 1, line: 48], nil}]
                        ]}
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 51],
           [
             {:users, [], [{:users, [version: 0, line: 51], nil}]},
             [
               do:
                 {:for, [line: 52],
                  [
                    {:<-, [line: 52],
                     [
                       {:when, [line: 52],
                        [
                          {{:type, [version: 1, line: 52], nil},
                           {:name, [version: 2, line: 52], nil}},
                          {{:., [line: 52], [:erlang, :"/="]}, [line: 52],
                           [{:type, [version: 1, line: 52], nil}, :guest]}
                        ]},
                       {:users, [version: 0, line: 52], nil}
                     ]},
                    [
                      into: [],
                      do:
                        {{:., [line: 53], [String, :upcase]}, [line: 53],
                         [{:name, [version: 2, line: 53], nil}]}
                    ]
                  ]}
             ]
           ]}
        ]}
   ]
 ]}

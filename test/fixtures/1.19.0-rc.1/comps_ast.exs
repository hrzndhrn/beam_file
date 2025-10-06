{:defmodule, [context: Elixir, import: Kernel],
 [
   {:__aliases__, [alias: false], [Comps]},
   [
     do:
       {:__block__, [],
        [
          {:def, [line: 2, column: 7],
           [
             {:one, [], Elixir},
             [
               do:
                 {:for, [line: 3, column: 5],
                  [
                    {:<-, [line: 3, column: 11],
                     [{:n, [version: 0, line: 3, column: 9], nil}, [1, 2, 3]]},
                    [
                      into: [],
                      do:
                        {{:., [line: 3, column: 31], [:erlang, :*]}, [line: 3, column: 31],
                         [
                           {:n, [version: 0, line: 3, column: 29], nil},
                           {:n, [version: 0, line: 3, column: 33], nil}
                         ]}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 6, column: 7],
           [
             {:two, [], Elixir},
             [
               do:
                 {:for, [line: 7, column: 5],
                  [
                    {:<-, [line: 7, column: 11],
                     [{:n, [version: 0, line: 7, column: 9], nil}, [1, 2, 3]]},
                    [
                      into: [],
                      do:
                        {{:., [line: 7, column: 41], [:erlang, :*]}, [line: 7, column: 41],
                         [
                           {:n, [version: 0, line: 7, column: 39], nil},
                           {:n, [version: 0, line: 7, column: 43], nil}
                         ]}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 10, column: 7],
           [
             {:three, [], Elixir},
             [
               do:
                 {:for, [line: 11, column: 5],
                  [
                    {:<-, [line: 11, column: 11],
                     [{:n, [version: 0, line: 11, column: 9], nil}, [1, 2, 3]]},
                    [
                      into: {:%{}, [line: 11, column: 31], []},
                      do:
                        {{:n, [version: 0, line: 11, column: 41], nil},
                         {{:., [line: 11, column: 46], [:erlang, :*]}, [line: 11, column: 46],
                          [
                            {:n, [version: 0, line: 11, column: 44], nil},
                            {:n, [version: 0, line: 11, column: 48], nil}
                          ]}}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 14, column: 7],
           [
             {:four, [], Elixir},
             [
               do:
                 {:for, [line: 15, column: 5],
                  [
                    {:<-, [line: 15, column: 11],
                     [{:i, [version: 0, line: 15, column: 9], nil}, [1, 2, 3]]},
                    {:<-, [line: 16, column: 11],
                     [{:n, [version: 1, line: 16, column: 9], nil}, [1, 2, 3]]},
                    [
                      into: {:%{}, [line: 17, column: 15], []},
                      do:
                        {{:i, [version: 0, line: 18, column: 14], nil},
                         {:n, [version: 1, line: 18, column: 17], nil}}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 21, column: 7],
           [
             {:five, [], Elixir},
             [
               do:
                 {:for, [line: 22, column: 5],
                  [
                    {:<<>>, [line: 22, column: 9],
                     [
                       {:<-, [line: 22, column: 13],
                        [
                          {:<<>>, [alignment: 0, line: 22, column: 9],
                           [
                             {:"::", [inferred_bitstring_spec: true, line: 22, column: 11],
                              [
                                {:x, [version: 0, line: 22, column: 11], nil},
                                {:integer, [line: 22, column: 11], nil}
                              ]}
                           ]},
                          "abcabc"
                        ]}
                     ]},
                    [
                      uniq: true,
                      into: "",
                      do:
                        {:<<>>, [alignment: 0, line: 22, column: 54],
                         [
                           {:"::", [inferred_bitstring_spec: true, line: 22, column: 58],
                            [
                              {{:., [line: 22, column: 58], [:erlang, :-]},
                               [line: 22, column: 58],
                               [{:x, [version: 0, line: 22, column: 56], nil}, 32]},
                              {:integer, [line: 22, column: 58], nil}
                            ]}
                         ]}
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 25, column: 7],
           [
             {:six, [], Elixir},
             [
               do:
                 {:for, [line: 26, column: 5],
                  [
                    {:<<>>, [line: 26, column: 9],
                     [
                       {:<-, [line: 26, column: 13],
                        [
                          {:<<>>, [alignment: 0, line: 26, column: 9],
                           [
                             {:"::", [inferred_bitstring_spec: true, line: 26, column: 11],
                              [
                                {:x, [version: 0, line: 26, column: 11], nil},
                                {:integer, [line: 26, column: 11], nil}
                              ]}
                           ]},
                          "AbCabCABc"
                        ]}
                     ]},
                    {{:., [line: 26], [:erlang, :andalso]}, [line: 26],
                     [
                       {{:., [line: 26], [:erlang, :is_integer]}, [line: 26],
                        [{:x, [version: 0, line: 26, column: 31], nil}]},
                       {{:., [line: 26], [:erlang, :andalso]}, [line: 26],
                        [
                          {{:., [line: 26], [:erlang, :>=]}, [line: 26],
                           [{:x, [version: 0, line: 26, column: 31], nil}, 97]},
                          {{:., [line: 26], [:erlang, :"=<"]}, [line: 26],
                           [{:x, [version: 0, line: 26, column: 31], nil}, 122]}
                        ]}
                     ]},
                    [
                      reduce: {:%{}, [line: 26, column: 52], []},
                      do: [
                        {:->, [line: 27, column: 11],
                         [
                           [{:acc, [version: 1, line: 27, column: 7], nil}],
                           {{:., [line: 27, column: 17], [Map, :update]}, [line: 27, column: 18],
                            [
                              {:acc, [version: 1, line: 27, column: 25], nil},
                              {:<<>>, [alignment: 0, line: 27, column: 30],
                               [
                                 {:"::",
                                  [
                                    inferred_bitstring_spec: true,
                                    line: 27,
                                    column: 32
                                  ],
                                  [
                                    {:x, [version: 0, line: 27, column: 32], nil},
                                    {:integer, [line: 27, column: 32], nil}
                                  ]}
                               ]},
                              1,
                              {:fn, [capture: true, line: 27, column: 45],
                               [
                                 {:->, [line: 27, column: 45],
                                  [
                                    [
                                      {:capture,
                                       [
                                         version: 2,
                                         counter: {Comps, 15},
                                         capture: 1,
                                         line: 27,
                                         column: 42
                                       ], nil}
                                    ],
                                    {{:., [line: 27, column: 45], [:erlang, :+]},
                                     [line: 27, column: 45],
                                     [
                                       {:capture,
                                        [
                                          version: 2,
                                          counter: {Comps, 15},
                                          capture: 1,
                                          line: 27,
                                          column: 42
                                        ], nil},
                                       1
                                     ]}
                                  ]}
                               ]}
                            ]}
                         ]}
                      ]
                    ]
                  ]}
             ]
           ]},
          {:def, [line: 31, column: 7],
           [
             {:seven, [], Elixir},
             [
               do:
                 {{:., [line: 32, column: 29], [:erlang, :++]}, [line: 32, column: 29],
                  [
                    {:for, [line: 32, column: 5],
                     [
                       {:<-, [line: 32, column: 11],
                        [{:x, [version: 0, line: 32, column: 9], nil}, [1, 2]]},
                       [into: [], do: {:x, [version: 0, line: 32, column: 26], nil}]
                     ]},
                    {:for, [line: 32, column: 32],
                     [
                       {:<-, [line: 32, column: 38],
                        [{:y, [version: 1, line: 32, column: 36], nil}, [3, 4]]},
                       [into: [], do: {:y, [version: 1, line: 32, column: 53], nil}]
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 35, column: 7],
           [
             {:eight, [], Elixir},
             [
               do:
                 {{:., [line: 36, column: 29], [:erlang, :--]}, [line: 36, column: 29],
                  [
                    {:for, [line: 36, column: 5],
                     [
                       {:<-, [line: 36, column: 11],
                        [{:x, [version: 0, line: 36, column: 9], nil}, [1, 2]]},
                       [into: [], do: {:x, [version: 0, line: 36, column: 26], nil}]
                     ]},
                    {:for, [line: 36, column: 32],
                     [
                       {:<-, [line: 36, column: 38],
                        [{:y, [version: 1, line: 36, column: 36], nil}, [3, 4]]},
                       [into: [], do: {:y, [version: 1, line: 36, column: 53], nil}]
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 39, column: 7],
           [
             {:nine, [], [{:list, [version: 0, line: 39, column: 12], nil}]},
             [
               do:
                 {{:., [line: 40, column: 10], [:erlang, :++]}, [line: 40, column: 10],
                  [
                    {:list, [version: 0, line: 40, column: 5], nil},
                    {{:., [line: 40, column: 17], [Enum, :sort]}, [line: 40, column: 18],
                     [
                       {:for, [line: 40, column: 23],
                        [
                          {:<-, [line: 40, column: 29],
                           [{:x, [version: 1, line: 40, column: 27], nil}, [1, 2]]},
                          [
                            into: [],
                            do: {:x, [version: 1, line: 40, column: 44], nil}
                          ]
                        ]}
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 43, column: 7],
           [
             {:ten, [], [{:list, [version: 0, line: 43, column: 11], nil}]},
             [
               do:
                 {{:., [line: 44, column: 12], [:erlang, :++]}, [line: 44, column: 13],
                  [
                    {:list, [version: 0, line: 44, column: 16], nil},
                    {{:., [line: 44, column: 26], [Enum, :sort]}, [line: 44, column: 27],
                     [
                       {:for, [line: 44, column: 32],
                        [
                          {:<-, [line: 44, column: 38],
                           [{:x, [version: 1, line: 44, column: 36], nil}, [1, 2]]},
                          [
                            into: [],
                            do: {:x, [version: 1, line: 44, column: 53], nil}
                          ]
                        ]}
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 47, column: 7],
           [
             {:eleven, [], [{:list, [version: 0, line: 47, column: 14], nil}]},
             [
               do:
                 {{:., [line: 48, column: 12], [:erlang, :--]}, [line: 48, column: 13],
                  [
                    {:list, [version: 0, line: 48, column: 16], nil},
                    {{:., [line: 48, column: 26], [Enum, :sort]}, [line: 48, column: 27],
                     [
                       {:for, [line: 48, column: 32],
                        [
                          {:<-, [line: 48, column: 38],
                           [{:x, [version: 1, line: 48, column: 36], nil}, [1, 2]]},
                          [
                            into: [],
                            do: {:x, [version: 1, line: 48, column: 53], nil}
                          ]
                        ]}
                     ]}
                  ]}
             ]
           ]},
          {:def, [line: 51, column: 7],
           [
             {:users, [], [{:users, [version: 0, line: 51, column: 13], nil}]},
             [
               do:
                 {:for, [line: 52, column: 5],
                  [
                    {:<-, [line: 52, column: 42],
                     [
                       {:when, [line: 52, column: 22],
                        [
                          {{:type, [version: 1, line: 52, column: 10], nil},
                           {:name, [version: 2, line: 52, column: 16], nil}},
                          {{:., [line: 52, column: 32], [:erlang, :"/="]}, [line: 52, column: 32],
                           [
                             {:type, [version: 1, line: 52, column: 27], nil},
                             :guest
                           ]}
                        ]},
                       {:users, [version: 0, line: 52, column: 45], nil}
                     ]},
                    [
                      into: [],
                      do:
                        {{:., [line: 53, column: 13], [String, :upcase]}, [line: 53, column: 14],
                         [{:name, [version: 2, line: 53, column: 21], nil}]}
                    ]
                  ]}
             ]
           ]}
        ]}
   ]
 ]}

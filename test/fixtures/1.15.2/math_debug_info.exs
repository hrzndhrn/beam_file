{:ok,
 {:debug_info_v1, :elixir_erl,
  {:elixir_v1,
   %{
     after_verify: [],
     attributes: [],
     compile_opts: [],
     definitions: [
       {{:triple, 1}, :def, [line: 34],
        [
          {[line: 34], [{:number, [version: 0, line: 34], nil}], [],
           {{:., [line: 34], [:erlang, :*]}, [line: 34],
            [3, {:number, [version: 0, line: 34], nil}]}}
        ]},
       {{:pi, 0}, :def, [line: 64],
        [
          {[line: 64], [], [], {{:., [line: 64], [Math.Const, :pi]}, [line: 64], []}}
        ]},
       {{:odd_or_even, 1}, :def, [line: 56],
        [
          {[line: 56], [{:a, [version: 0, line: 56], nil}], [],
           {:case, [line: 57, optimize_boolean: true],
            [
              {{:., [line: 57], [:erlang, :==]}, [line: 57],
               [
                 {{:., [line: 57], [:erlang, :rem]}, [line: 57],
                  [{:a, [version: 0, line: 57], nil}, 2]},
                 0
               ]},
              [
                do: [
                  {:->, [generated: true, line: 57], [[false], :odd]},
                  {:->, [generated: true, line: 57], [[true], :even]}
                ]
              ]
            ]}}
        ]},
       {{:double, 1}, :def, [line: 28],
        [
          {[line: 28], [{:number, [version: 0, line: 28], nil}], [],
           {:add, [line: 28],
            [
              {{:number, [version: 0, line: 28], nil}, {:number, [version: 0, line: 28], nil}}
            ]}}
        ]},
       {{:divide, 2}, :def, [line: 43],
        [
          {[line: 43],
           [
             {:a, [version: 0, line: 43], nil},
             {:b, [version: 1, line: 43], nil}
           ],
           [
             {{:., [line: 43], [:erlang, :"/="]}, [line: 43],
              [{:b, [version: 1, line: 43], nil}, 0]}
           ],
           {{:., [line: 44], [:erlang, :div]}, [line: 44],
            [
              {:a, [version: 0, line: 44], nil},
              {:b, [version: 1, line: 44], nil}
            ]}}
        ]},
       {{:biggest, 2}, :defmacro, [line: 50],
        [
          {[line: 50],
           [
             {:a, [version: 0, line: 50], nil},
             {:b, [version: 1, line: 50], nil}
           ], [],
           {:{}, [],
            [
              :max,
              [context: Math, imports: [{2, Kernel}]],
              [
                {:a, [version: 0, line: 52], nil},
                {:b, [version: 1, line: 52], nil}
              ]
            ]}}
        ]},
       {{:add, 2}, :def, [line: 20],
        [
          {[line: 20],
           [
             {:number_a, [version: 0, line: 20], nil},
             {:number_b, [version: 1, line: 20], nil}
           ], [],
           {{:., [line: 21], [:erlang, :+]}, [line: 21],
            [
              {:number_a, [version: 0, line: 21], nil},
              {:number_b, [version: 1, line: 21], nil}
            ]}}
        ]},
       {{:add, 1}, :defp, [line: 37],
        [
          {[line: 37], [{:nums, [version: 0, line: 37], nil}], [],
           {:__block__, [],
            [
              {:=, [line: 38],
               [
                 {{:number_a, [version: 1, line: 38], nil},
                  {:number_b, [version: 2, line: 38], nil}},
                 {:nums, [version: 0, line: 38], nil}
               ]},
              {:add, [line: 39],
               [
                 {:number_a, [version: 1, line: 39], nil},
                 {:number_b, [version: 2, line: 39], nil}
               ]}
            ]}}
        ]}
     ],
     deprecated: [],
     file: "/Users/kruse/Projects/hrzndhrn/beam_file/test/fixtures/math.ex",
     is_behaviour: false,
     line: 1,
     module: Math,
     relative_file: "test/fixtures/math.ex",
     struct: nil,
     unreachable: []
   },
   [
     {:attribute, 33, :spec,
      {{:triple, 1},
       [
         {:type, 33, :fun,
          [
            {:type, 33, :product, [{:user_type, 33, :num, []}]},
            {:user_type, 33, :x, []}
          ]}
       ]}},
     {:attribute, 27, :spec,
      {{:double, 1},
       [
         {:type, 27, :fun,
          [
            {:type, 27, :product, [{:user_type, 27, :num, []}]},
            {:user_type, 27, :x, []}
          ]}
       ]}},
     {:attribute, 42, :spec,
      {{:divide, 2},
       [
         {:type, 42, :fun,
          [
            {:type, 42, :product, [{:user_type, 42, :num, []}, {:user_type, 42, :num, []}]},
            {:user_type, 42, :x, []}
          ]}
       ]}},
     {:attribute, 19, :spec,
      {{:add, 2},
       [
         {:type, 19, :fun,
          [
            {:type, 19, :product,
             [
               {:type, 19, :union,
                [{:user_type, 19, :num, []}, {:user_type, 19, :num_tuple, []}]},
               {:user_type, 19, :num, []}
             ]},
            {:user_type, 19, :x, []}
          ]}
       ]}},
     {:attribute, 36, :spec,
      {{:add, 1},
       [
         {:type, 36, :fun,
          [
            {:type, 36, :product, [{:user_type, 36, :num_tuple, []}]},
            {:user_type, 36, :x, []}
          ]}
       ]}},
     {:attribute, 12, :type,
      {:num_tuple, {:type, 0, :tuple, [{:user_type, 12, :num, []}, {:user_type, 12, :num, []}]},
       []}},
     {:attribute, 10, :export_type, [x: 0]},
     {:attribute, 10, :opaque, {:x, {:user_type, 10, :num, []}, []}},
     {:attribute, 9, :export_type, [num: 0]},
     {:attribute, 9, :type, {:num, {:type, 9, :integer, []}, []}}
   ]}}}

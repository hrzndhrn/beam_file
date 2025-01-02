{:ok,
 {:debug_info_v1, :elixir_erl,
  {:elixir_v1,
   %{
     attributes: [],
     line: 1,
     module: Math,
     file: "/Users/kruse/Projects/hrzndhrn/beam_file/test/fixtures/math.ex",
     deprecated: [],
     unreachable: [],
     struct: nil,
     after_verify: [],
     defines_behaviour: false,
     definitions: [
       {{:triple, 1}, :def, [line: 34, column: 7],
        [
          {[line: 34, column: 7], [{:number, [version: 0, line: 34, column: 14], nil}], [],
           {{:., [line: 34, column: 34], [:erlang, :*]}, [line: 34, column: 34],
            [3, {:number, [version: 0, line: 34, column: 36], nil}]}}
        ]},
       {{:pi, 0}, :def, [line: 64, column: 7],
        [
          {[line: 64, column: 7], [], [],
           {{:., [line: 64, column: 20], [Math.Const, :pi]}, [line: 64, column: 21], []}}
        ]},
       {{:odd_or_even, 1}, :def, [line: 56, column: 7],
        [
          {[line: 56, column: 7], [{:a, [version: 0, line: 56, column: 19], nil}], [],
           {:case, [line: 57, optimize_boolean: true],
            [
              {{:., [line: 57, column: 18], [:erlang, :==]}, [line: 57, column: 18],
               [
                 {{:., [line: 57, column: 8], [:erlang, :rem]}, [line: 57, column: 8],
                  [{:a, [version: 0, line: 57, column: 12], nil}, 2]},
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
       {{:double, 1}, :def, [line: 28, column: 7],
        [
          {[line: 28, column: 7], [{:number, [version: 0, line: 28, column: 14], nil}], [],
           {:add, [line: 28, column: 27],
            [
              {{:number, [version: 0, line: 28, column: 32], nil},
               {:number, [version: 0, line: 28, column: 40], nil}}
            ]}}
        ]},
       {{:divide, 2}, :def, [line: 43, column: 7],
        [
          {[line: 43, column: 7],
           [
             {:a, [version: 0, line: 43, column: 14], nil},
             {:b, [version: 1, line: 43, column: 17], nil}
           ],
           [
             {{:., [line: 43, column: 27], [:erlang, :"/="]}, [line: 43, column: 27],
              [{:b, [version: 1, line: 43, column: 25], nil}, 0]}
           ],
           {{:., [line: 44, column: 5], [:erlang, :div]}, [line: 44, column: 5],
            [
              {:a, [version: 0, line: 44, column: 9], nil},
              {:b, [version: 1, line: 44, column: 12], nil}
            ]}}
        ]},
       {{:biggest, 2}, :defmacro, [line: 50, column: 12],
        [
          {[line: 50, column: 12],
           [
             {:a, [version: 0, line: 50, column: 20], nil},
             {:b, [version: 1, line: 50, column: 23], nil}
           ], [],
           {:{}, [],
            [
              :max,
              [context: Math, imports: [{2, Kernel}]],
              [
                {:a, [version: 0, line: 52, column: 19], nil},
                {:b, [version: 1, line: 52, column: 31], nil}
              ]
            ]}}
        ]},
       {{:add, 2}, :def, [line: 20, column: 7],
        [
          {[line: 20, column: 7],
           [
             {:number_a, [version: 0, line: 20, column: 11], nil},
             {:number_b, [version: 1, line: 20, column: 21], nil}
           ], [],
           {{:., [line: 21, column: 14], [:erlang, :+]}, [line: 21, column: 14],
            [
              {:number_a, [version: 0, line: 21, column: 5], nil},
              {:number_b, [version: 1, line: 21, column: 16], nil}
            ]}}
        ]},
       {{:add, 1}, :defp, [line: 37, column: 8],
        [
          {[line: 37, column: 8], [{:nums, [version: 0, line: 37, column: 12], nil}], [],
           {:__block__, [],
            [
              {:=, [line: 38, column: 26],
               [
                 {{:number_a, [version: 1, line: 38, column: 6], nil},
                  {:number_b, [version: 2, line: 38, column: 16], nil}},
                 {:nums, [version: 0, line: 38, column: 28], nil}
               ]},
              {:add, [line: 39, column: 5],
               [
                 {:number_a, [version: 1, line: 39, column: 9], nil},
                 {:number_b, [version: 2, line: 39, column: 19], nil}
               ]}
            ]}}
        ]}
     ],
     uses_behaviours: [],
     impls: [],
     compile_opts: [],
     relative_file: "test/fixtures/math.ex"
   },
   [
     {:attribute, 33, :spec,
      {{:triple, 1},
       [
         {:type, {33, 23}, :fun,
          [
            {:type, {33, 23}, :product, [{:user_type, {33, 16}, :num, []}]},
            {:user_type, {33, 26}, :x, []}
          ]}
       ]}},
     {:attribute, 27, :spec,
      {{:double, 1},
       [
         {:type, {27, 23}, :fun,
          [
            {:type, {27, 23}, :product, [{:user_type, {27, 16}, :num, []}]},
            {:user_type, {27, 26}, :x, []}
          ]}
       ]}},
     {:attribute, 42, :spec,
      {{:divide, 2},
       [
         {:type, {42, 30}, :fun,
          [
            {:type, {42, 30}, :product,
             [
               {:user_type, {42, 16}, :num, []},
               {:user_type, {42, 23}, :num, []}
             ]},
            {:user_type, {42, 33}, :x, []}
          ]}
       ]}},
     {:attribute, 19, :spec,
      {{:add, 2},
       [
         {:type, {19, 41}, :fun,
          [
            {:type, {19, 41}, :product,
             [
               {:type, {19, 19}, :union,
                [
                  {:user_type, {19, 13}, :num, []},
                  {:user_type, {19, 21}, :num_tuple, []}
                ]},
               {:user_type, {19, 34}, :num, []}
             ]},
            {:user_type, {19, 44}, :x, []}
          ]}
       ]}},
     {:attribute, 36, :spec,
      {{:add, 1},
       [
         {:type, {36, 26}, :fun,
          [
            {:type, {36, 26}, :product, [{:user_type, {36, 13}, :num_tuple, []}]},
            {:user_type, {36, 29}, :x, []}
          ]}
       ]}},
     {:attribute, 12, :type,
      {:num_tuple,
       {:type, 0, :tuple, [{:user_type, {12, 24}, :num, []}, {:user_type, {12, 31}, :num, []}]},
       []}},
     {:attribute, 10, :export_type, [x: 0]},
     {:attribute, 10, :opaque, {:x, {:user_type, {10, 16}, :num, []}, []}},
     {:attribute, 9, :export_type, [num: 0]},
     {:attribute, 9, :type, {:num, {:type, {9, 16}, :integer, []}, []}}
   ]}}}

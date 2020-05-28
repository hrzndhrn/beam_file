{:ok,
 {:debug_info_v1, :elixir_erl,
  {:elixir_v1,
   %{
     attributes: [],
     compile_opts: [],
     definitions: [
       {{:triple, 1}, :def, [line: 25],
        [
          {[line: 25], [{:number, [version: 0, line: 25], nil}], [],
           {{:., [], [:erlang, :*]}, [line: 25], [3, {:number, [version: 0, line: 25], nil}]}}
        ]},
       {{:pi, 0}, :def, [line: 46],
        [{[line: 46], [], [], {{:., [line: 46], [Math.Const, :pi]}, [line: 46], []}}]},
       {{:odd_or_even, 1}, :def, [line: 38],
        [
          {[line: 38], [{:a, [version: 0, line: 38], nil}], [],
           {:case, [line: 39, optimize_boolean: true],
            [
              {{:., [], [:erlang, :==]}, [line: 39],
               [
                 {{:., [], [:erlang, :rem]}, [line: 39], [{:a, [version: 0, line: 39], nil}, 2]},
                 0
               ]},
              [
                do: [
                  {:->, [generated: true, line: 39], [[false], :odd]},
                  {:->, [generated: true, line: 39], [[true], :even]}
                ]
              ]
            ]}}
        ]},
       {{:double, 1}, :def, [line: 21],
        [
          {[line: 21], [{:number, [version: 0, line: 21], nil}], [],
           {:add, [line: 21],
            [{{:number, [version: 0, line: 21], nil}, {:number, [version: 0, line: 21], nil}}]}}
        ]},
       {{:divide, 2}, :def, [line: 34],
        [
          {[line: 34], [{:a, [version: 0, line: 34], nil}, {:b, [version: 1, line: 34], nil}],
           [{{:., [], [:erlang, :"/="]}, [line: 34], [{:b, [version: 1, line: 34], nil}, 0]}],
           {{:., [], [:erlang, :div]}, [line: 35],
            [{:a, [version: 0, line: 35], nil}, {:b, [version: 1, line: 35], nil}]}}
        ]},
       {{:add, 2}, :def, [line: 15],
        [
          {[line: 15],
           [{:number_a, [version: 0, line: 15], nil}, {:number_b, [version: 1, line: 15], nil}],
           [],
           {{:., [], [:erlang, :+]}, [line: 16],
            [{:number_a, [version: 0, line: 16], nil}, {:number_b, [version: 1, line: 16], nil}]}}
        ]},
       {{:add, 1}, :defp, [line: 28],
        [
          {[line: 28], [{:nums, [version: 0, line: 28], nil}], [],
           {:__block__, [],
            [
              {:=, [line: 29],
               [
                 {{:number_a, [version: 1, line: 29], nil},
                  {:number_b, [version: 2, line: 29], nil}},
                 {:nums, [version: 0, line: 29], nil}
               ]},
              {:add, [line: 30],
               [
                 {:number_a, [version: 1, line: 30], nil},
                 {:number_b, [version: 2, line: 30], nil}
               ]}
            ]}}
        ]}
     ],
     deprecated: [],
     file: "/Users/kruse/Projects/beam_file/test/fixtures/math.ex",
     is_behaviour: false,
     line: 1,
     module: Math,
     relative_file: "test/fixtures/math.ex",
     unreachable: []
   },
   [
     {:attribute, 24, :spec,
      {{:triple, 1},
       [
         {:type, 24, :fun,
          [{:type, 24, :product, [{:user_type, 24, :num, []}]}, {:user_type, 24, :x, []}]}
       ]}},
     {:attribute, 20, :spec,
      {{:double, 1},
       [
         {:type, 20, :fun,
          [{:type, 20, :product, [{:user_type, 20, :num, []}]}, {:user_type, 20, :x, []}]}
       ]}},
     {:attribute, 33, :spec,
      {{:divide, 2},
       [
         {:type, 33, :fun,
          [
            {:type, 33, :product, [{:user_type, 33, :num, []}, {:user_type, 33, :num, []}]},
            {:user_type, 33, :x, []}
          ]}
       ]}},
     {:attribute, 14, :spec,
      {{:add, 2},
       [
         {:type, 14, :fun,
          [
            {:type, 14, :product,
             [
               {:type, 14, :union,
                [{:user_type, 14, :num, []}, {:user_type, 14, :num_tuple, []}]},
               {:user_type, 14, :num, []}
             ]},
            {:user_type, 14, :x, []}
          ]}
       ]}},
     {:attribute, 27, :spec,
      {{:add, 1},
       [
         {:type, 27, :fun,
          [{:type, 27, :product, [{:user_type, 27, :num_tuple, []}]}, {:user_type, 27, :x, []}]}
       ]}},
     {:attribute, 9, :type,
      {:num_tuple, {:type, 0, :tuple, [{:user_type, 9, :num, []}, {:user_type, 9, :num, []}]}, []}},
     {:attribute, 7, :export_type, [x: 0]},
     {:attribute, 7, :opaque, {:x, {:user_type, 7, :num, []}, []}},
     {:attribute, 6, :export_type, [num: 0]},
     {:attribute, 6, :type, {:num, {:type, 6, :integer, []}, []}}
   ]}}}

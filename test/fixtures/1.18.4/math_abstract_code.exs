{:ok,
 [
   {:attribute, 1, :file, {~c"test/fixtures/math.ex", 1}},
   {:attribute, 1, :module, Math},
   {:attribute, 1, :compile, [:no_auto_import]},
   {:attribute, 33, :spec,
    {{:triple, 1},
     [
       {:type, {33, 9}, :fun,
        [
          {:type, {33, 9}, :product, [{:user_type, {33, 16}, :num, []}]},
          {:user_type, {33, 26}, :x, []}
        ]}
     ]}},
   {:attribute, 27, :spec,
    {{:double, 1},
     [
       {:type, {27, 9}, :fun,
        [
          {:type, {27, 9}, :product, [{:user_type, {27, 16}, :num, []}]},
          {:user_type, {27, 26}, :x, []}
        ]}
     ]}},
   {:attribute, 42, :spec,
    {{:divide, 2},
     [
       {:type, {42, 9}, :fun,
        [
          {:type, {42, 9}, :product,
           [{:user_type, {42, 16}, :num, []}, {:user_type, {42, 23}, :num, []}]},
          {:user_type, {42, 33}, :x, []}
        ]}
     ]}},
   {:attribute, 19, :spec,
    {{:add, 2},
     [
       {:type, {19, 9}, :fun,
        [
          {:type, {19, 9}, :product,
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
       {:type, {36, 9}, :fun,
        [
          {:type, {36, 9}, :product, [{:user_type, {36, 13}, :num_tuple, []}]},
          {:user_type, {36, 29}, :x, []}
        ]}
     ]}},
   {:attribute, 12, :type,
    {:num_tuple,
     {:type, 0, :tuple, [{:user_type, {12, 24}, :num, []}, {:user_type, {12, 31}, :num, []}]}, []}},
   {:attribute, 10, :export_type, [x: 0]},
   {:attribute, 10, :opaque, {:x, {:user_type, {10, 16}, :num, []}, []}},
   {:attribute, 9, :export_type, [num: 0]},
   {:attribute, 9, :type, {:num, {:type, {9, 16}, :integer, []}, []}},
   {:attribute, 1, :export,
    [
      "MACRO-biggest": 3,
      __info__: 1,
      add: 2,
      divide: 2,
      double: 1,
      odd_or_even: 1,
      pi: 0,
      triple: 1
    ]},
   {:attribute, 1, :spec,
    {{:__info__, 1},
     [
       {:type, 1, :fun,
        [
          {:type, 1, :product,
           [
             {:type, 1, :union,
              [
                {:atom, 1, :attributes},
                {:atom, 1, :compile},
                {:atom, 1, :functions},
                {:atom, 1, :macros},
                {:atom, 1, :md5},
                {:atom, 1, :exports_md5},
                {:atom, 1, :module},
                {:atom, 1, :deprecated},
                {:atom, 1, :struct}
              ]}
           ]},
          {:type, 1, :any, []}
        ]}
     ]}},
   {:function, 0, :__info__, 1,
    [
      {:clause, 0, [{:atom, 0, :module}], [], [{:atom, 0, Math}]},
      {:clause, 0, [{:atom, 0, :functions}], [],
       [
         {:cons, 0, {:tuple, 0, [{:atom, 0, :add}, {:integer, 0, 2}]},
          {:cons, 0, {:tuple, 0, [{:atom, 0, :divide}, {:integer, 0, 2}]},
           {:cons, 0, {:tuple, 0, [{:atom, 0, :double}, {:integer, 0, 1}]},
            {:cons, 0, {:tuple, 0, [{:atom, 0, :odd_or_even}, {:integer, 0, 1}]},
             {:cons, 0, {:tuple, 0, [{:atom, 0, :pi}, {:integer, 0, 0}]},
              {:cons, 0, {:tuple, 0, [{:atom, 0, :triple}, {:integer, 0, 1}]}, {nil, 0}}}}}}}
       ]},
      {:clause, 0, [{:atom, 0, :macros}], [],
       [
         {:cons, 0, {:tuple, 0, [{:atom, 0, :biggest}, {:integer, 0, 2}]}, {nil, 0}}
       ]},
      {:clause, 0, [{:atom, 0, :struct}], [], [{:atom, 0, nil}]},
      {:clause, 0, [{:atom, 0, :exports_md5}], [],
       [
         {:bin, 0,
          [
            {:bin_element, 0,
             {:string, 0,
              [249, 211, 203, 155, 203, 249, 239, 130, 36, 46, 173, 111, 187, 184, 168, 24]},
             :default, :default}
          ]}
       ]},
      {:clause, 0, [{:match, 0, {:var, 0, :Key}, {:atom, 0, :attributes}}], [],
       [
         {:call, 0, {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
          [{:atom, 0, Math}, {:var, 0, :Key}]}
       ]},
      {:clause, 0, [{:match, 0, {:var, 0, :Key}, {:atom, 0, :compile}}], [],
       [
         {:call, 0, {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
          [{:atom, 0, Math}, {:var, 0, :Key}]}
       ]},
      {:clause, 0, [{:match, 0, {:var, 0, :Key}, {:atom, 0, :md5}}], [],
       [
         {:call, 0, {:remote, 0, {:atom, 0, :erlang}, {:atom, 0, :get_module_info}},
          [{:atom, 0, Math}, {:var, 0, :Key}]}
       ]},
      {:clause, 0, [{:atom, 0, :deprecated}], [], [nil: 0]}
    ]},
   {:function, {37, 8}, :add, 1,
    [
      {:clause, {37, 8}, [{:var, {37, 12}, :_nums@1}], [],
       [
         {:match, {38, 26},
          {:tuple, {38, 26}, [{:var, {38, 6}, :_number_a@1}, {:var, {38, 16}, :_number_b@1}]},
          {:var, {38, 28}, :_nums@1}},
         {:call, {39, 5}, {:atom, {39, 5}, :add},
          [{:var, {39, 9}, :_number_a@1}, {:var, {39, 19}, :_number_b@1}]}
       ]}
    ]},
   {:function, {20, 7}, :add, 2,
    [
      {:clause, {20, 7}, [{:var, {20, 11}, :_number_a@1}, {:var, {20, 21}, :_number_b@1}], [],
       [
         {:op, {21, 14}, :+, {:var, {21, 5}, :_number_a@1}, {:var, {21, 16}, :_number_b@1}}
       ]}
    ]},
   {:function, {50, 12}, :"MACRO-biggest", 3,
    [
      {:clause, {50, 12},
       [
         {:var, {50, 12}, :_@CALLER},
         {:var, {50, 20}, :_a@1},
         {:var, {50, 23}, :_b@1}
       ], [],
       [
         {:tuple, 0,
          [
            {:atom, 0, :max},
            {:cons, 0, {:tuple, 0, [{:atom, 0, :context}, {:atom, 0, Math}]},
             {:cons, 0,
              {:tuple, 0,
               [
                 {:atom, 0, :imports},
                 {:cons, 0, {:tuple, 0, [{:integer, 0, 2}, {:atom, 0, Kernel}]}, {nil, 0}}
               ]}, {nil, 0}}},
            {:cons, 0,
             {:call, {52, 11},
              {:remote, {52, 11}, {:atom, {52, 11}, :elixir_quote},
               {:atom, {52, 11}, :shallow_validate_ast}}, [{:var, {52, 19}, :_a@1}]},
             {:cons, 0,
              {:call, {52, 23},
               {:remote, {52, 23}, {:atom, {52, 23}, :elixir_quote},
                {:atom, {52, 23}, :shallow_validate_ast}}, [{:var, {52, 31}, :_b@1}]}, {nil, 0}}}
          ]}
       ]}
    ]},
   {:function, {43, 7}, :divide, 2,
    [
      {:clause, {43, 7}, [{:var, {43, 14}, :_a@1}, {:var, {43, 17}, :_b@1}],
       [
         [
           {:op, {43, 27}, :"/=", {:var, {43, 25}, :_b@1}, {:integer, {43, 27}, 0}}
         ]
       ], [{:op, {44, 5}, :div, {:var, {44, 9}, :_a@1}, {:var, {44, 12}, :_b@1}}]}
    ]},
   {:function, {28, 7}, :double, 1,
    [
      {:clause, {28, 7}, [{:var, {28, 14}, :_number@1}], [],
       [
         {:call, {28, 27}, {:atom, {28, 27}, :add},
          [
            {:tuple, {28, 27}, [{:var, {28, 32}, :_number@1}, {:var, {28, 40}, :_number@1}]}
          ]}
       ]}
    ]},
   {:function, {56, 7}, :odd_or_even, 1,
    [
      {:clause, {56, 7}, [{:var, {56, 19}, :_a@1}], [],
       [
         {:case, 57,
          {:op, {57, 18}, :==,
           {:op, {57, 8}, :rem, {:var, {57, 12}, :_a@1}, {:integer, {57, 8}, 2}},
           {:integer, {57, 18}, 0}},
          [
            {:clause, [generated: true, location: 57],
             [{:atom, [generated: true, location: 57], false}], [],
             [{:atom, [generated: true, location: 57], :odd}]},
            {:clause, [generated: true, location: 57],
             [{:atom, [generated: true, location: 57], true}], [],
             [{:atom, [generated: true, location: 57], :even}]}
          ]}
       ]}
    ]},
   {:function, {64, 7}, :pi, 0,
    [
      {:clause, {64, 7}, [], [],
       [
         {:call, {64, 21},
          {:remote, {64, 21}, {:atom, {64, 21}, Math.Const}, {:atom, {64, 21}, :pi}}, []}
       ]}
    ]},
   {:function, {34, 7}, :triple, 1,
    [
      {:clause, {34, 7}, [{:var, {34, 14}, :_number@1}], [],
       [
         {:op, {34, 34}, :*, {:integer, {34, 34}, 3}, {:var, {34, 36}, :_number@1}}
       ]}
    ]}
 ]}

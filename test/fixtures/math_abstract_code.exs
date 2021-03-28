{:ok,
 [
   {:attribute, 1, :file, {'test/fixtures/math.ex', 1}},
   {:attribute, 1, :module, Math},
   {:attribute, 1, :compile, [:no_auto_import]},
   {:attribute, 24, :spec,
    {{:triple, 1},
     [
       {:type, 24, :fun,
        [
          {:type, 24, :product, [{:user_type, 24, :num, []}]},
          {:user_type, 24, :x, []}
        ]}
     ]}},
   {:attribute, 20, :spec,
    {{:double, 1},
     [
       {:type, 20, :fun,
        [
          {:type, 20, :product, [{:user_type, 20, :num, []}]},
          {:user_type, 20, :x, []}
        ]}
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
             {:type, 14, :union, [{:user_type, 14, :num, []}, {:user_type, 14, :num_tuple, []}]},
             {:user_type, 14, :num, []}
           ]},
          {:user_type, 14, :x, []}
        ]}
     ]}},
   {:attribute, 27, :spec,
    {{:add, 1},
     [
       {:type, 27, :fun,
        [
          {:type, 27, :product, [{:user_type, 27, :num_tuple, []}]},
          {:user_type, 27, :x, []}
        ]}
     ]}},
   {:attribute, 9, :type,
    {:num_tuple, {:type, 0, :tuple, [{:user_type, 9, :num, []}, {:user_type, 9, :num, []}]}, []}},
   {:attribute, 7, :export_type, [x: 0]},
   {:attribute, 7, :opaque, {:x, {:user_type, 7, :num, []}, []}},
   {:attribute, 6, :export_type, [num: 0]},
   {:attribute, 6, :type, {:num, {:type, 6, :integer, []}, []}},
   {:attribute, 1, :export,
    [
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
                {:atom, 1, :deprecated}
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
      {:clause, 0, [{:atom, 0, :macros}], [], [nil: 0]},
      {:clause, 0, [{:atom, 0, :exports_md5}], [],
       [
         {:bin, 0,
          [
            {:bin_element, 0,
             {:string, 0,
              [25, 151, 48, 100, 191, 19, 254, 0, 234, 227, 203, 3, 209, 77, 44, 222]}, :default,
             :default}
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
   {:function, 28, :add, 1,
    [
      {:clause, 28, [{:var, 28, :_nums@1}], [],
       [
         {:match, 29, {:tuple, 0, [{:var, 29, :_number_a@1}, {:var, 29, :_number_b@1}]},
          {:var, 29, :_nums@1}},
         {:call, 30, {:atom, 30, :add}, [{:var, 30, :_number_a@1}, {:var, 30, :_number_b@1}]}
       ]}
    ]},
   {:function, 15, :add, 2,
    [
      {:clause, 15, [{:var, 15, :_number_a@1}, {:var, 15, :_number_b@1}], [],
       [{:op, 16, :+, {:var, 16, :_number_a@1}, {:var, 16, :_number_b@1}}]}
    ]},
   {:function, 34, :divide, 2,
    [
      {:clause, 34, [{:var, 34, :_a@1}, {:var, 34, :_b@1}],
       [[{:op, 34, :"/=", {:var, 34, :_b@1}, {:integer, 0, 0}}]],
       [{:op, 35, :div, {:var, 35, :_a@1}, {:var, 35, :_b@1}}]}
    ]},
   {:function, 21, :double, 1,
    [
      {:clause, 21, [{:var, 21, :_number@1}], [],
       [
         {:call, 21, {:atom, 21, :add},
          [{:tuple, 0, [{:var, 21, :_number@1}, {:var, 21, :_number@1}]}]}
       ]}
    ]},
   {:function, 38, :odd_or_even, 1,
    [
      {:clause, 38, [{:var, 38, :_a@1}], [],
       [
         {:case, 39,
          {:op, 39, :==, {:op, 39, :rem, {:var, 39, :_a@1}, {:integer, 0, 2}}, {:integer, 0, 0}},
          [
            {:clause, [generated: true, location: 39], [{:atom, 0, false}], [],
             [{:atom, 0, :odd}]},
            {:clause, [generated: true, location: 39], [{:atom, 0, true}], [],
             [{:atom, 0, :even}]}
          ]}
       ]}
    ]},
   {:function, 46, :pi, 0,
    [
      {:clause, 46, [], [],
       [
         {:call, 46, {:remote, 46, {:atom, 0, Math.Const}, {:atom, 46, :pi}}, []}
       ]}
    ]},
   {:function, 25, :triple, 1,
    [
      {:clause, 25, [{:var, 25, :_number@1}], [],
       [{:op, 25, :*, {:integer, 0, 3}, {:var, 25, :_number@1}}]}
    ]}
 ]}

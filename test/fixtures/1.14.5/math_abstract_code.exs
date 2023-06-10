{
  :ok,
  [
    {:attribute, 1, :file, {'test/fixtures/math.ex', 1}},
    {:attribute, 1, :module, Math},
    {:attribute, 1, :compile, [:no_auto_import]},
    {
      :attribute,
      33,
      :spec,
      {
        {:triple, 1},
        [
          {
            :type,
            33,
            :fun,
            [
              {:type, 33, :product, [{:user_type, 33, :num, []}]},
              {:user_type, 33, :x, []}
            ]
          }
        ]
      }
    },
    {
      :attribute,
      27,
      :spec,
      {
        {:double, 1},
        [
          {
            :type,
            27,
            :fun,
            [
              {:type, 27, :product, [{:user_type, 27, :num, []}]},
              {:user_type, 27, :x, []}
            ]
          }
        ]
      }
    },
    {
      :attribute,
      42,
      :spec,
      {
        {:divide, 2},
        [
          {
            :type,
            42,
            :fun,
            [
              {
                :type,
                42,
                :product,
                [{:user_type, 42, :num, []}, {:user_type, 42, :num, []}]
              },
              {:user_type, 42, :x, []}
            ]
          }
        ]
      }
    },
    {
      :attribute,
      19,
      :spec,
      {
        {:add, 2},
        [
          {
            :type,
            19,
            :fun,
            [
              {
                :type,
                19,
                :product,
                [
                  {
                    :type,
                    19,
                    :union,
                    [
                      {:user_type, 19, :num, []},
                      {:user_type, 19, :num_tuple, []}
                    ]
                  },
                  {:user_type, 19, :num, []}
                ]
              },
              {:user_type, 19, :x, []}
            ]
          }
        ]
      }
    },
    {
      :attribute,
      36,
      :spec,
      {
        {:add, 1},
        [
          {
            :type,
            36,
            :fun,
            [
              {:type, 36, :product, [{:user_type, 36, :num_tuple, []}]},
              {:user_type, 36, :x, []}
            ]
          }
        ]
      }
    },
    {
      :attribute,
      12,
      :type,
      {
        :num_tuple,
        {
          :type,
          0,
          :tuple,
          [{:user_type, 12, :num, []}, {:user_type, 12, :num, []}]
        },
        []
      }
    },
    {:attribute, 10, :export_type, [x: 0]},
    {:attribute, 10, :opaque, {:x, {:user_type, 10, :num, []}, []}},
    {:attribute, 9, :export_type, [num: 0]},
    {:attribute, 9, :type, {:num, {:type, 9, :integer, []}, []}},
    {
      :attribute,
      1,
      :export,
      [
        "MACRO-biggest": 3,
        __info__: 1,
        add: 2,
        divide: 2,
        double: 1,
        odd_or_even: 1,
        pi: 0,
        triple: 1
      ]
    },
    {
      :attribute,
      1,
      :spec,
      {
        {:__info__, 1},
        [
          {
            :type,
            1,
            :fun,
            [
              {
                :type,
                1,
                :product,
                [
                  {
                    :type,
                    1,
                    :union,
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
                    ]
                  }
                ]
              },
              {:type, 1, :any, []}
            ]
          }
        ]
      }
    },
    {
      :function,
      0,
      :__info__,
      1,
      [
        {:clause, 0, [{:atom, 0, :module}], [], [{:atom, 0, Math}]},
        {
          :clause,
          0,
          [{:atom, 0, :functions}],
          [],
          [
            {
              :cons,
              0,
              {:tuple, 0, [{:atom, 0, :add}, {:integer, 0, 2}]},
              {
                :cons,
                0,
                {:tuple, 0, [{:atom, 0, :divide}, {:integer, 0, 2}]},
                {
                  :cons,
                  0,
                  {:tuple, 0, [{:atom, 0, :double}, {:integer, 0, 1}]},
                  {
                    :cons,
                    0,
                    {
                      :tuple,
                      0,
                      [{:atom, 0, :odd_or_even}, {:integer, 0, 1}]
                    },
                    {
                      :cons,
                      0,
                      {:tuple, 0, [{:atom, 0, :pi}, {:integer, 0, 0}]},
                      {
                        :cons,
                        0,
                        {:tuple, 0, [{:atom, 0, :triple}, {:integer, 0, 1}]},
                        {nil, 0}
                      }
                    }
                  }
                }
              }
            }
          ]
        },
        {
          :clause,
          0,
          [{:atom, 0, :macros}],
          [],
          [
            {
              :cons,
              0,
              {:tuple, 0, [{:atom, 0, :biggest}, {:integer, 0, 2}]},
              {nil, 0}
            }
          ]
        },
        {:clause, 0, [{:atom, 0, :struct}], [], [{:atom, 0, nil}]},
        {
          :clause,
          0,
          [{:atom, 0, :exports_md5}],
          [],
          [
            {
              :bin,
              0,
              [
                {
                  :bin_element,
                  0,
                  {
                    :string,
                    0,
                    [
                      249,
                      211,
                      203,
                      155,
                      203,
                      249,
                      239,
                      130,
                      36,
                      46,
                      173,
                      111,
                      187,
                      184,
                      168,
                      24
                    ]
                  },
                  :default,
                  :default
                }
              ]
            }
          ]
        },
        {
          :clause,
          0,
          [{:match, 0, {:var, 0, :Key}, {:atom, 0, :attributes}}],
          [],
          [
            {
              :call,
              0,
              {
                :remote,
                0,
                {:atom, 0, :erlang},
                {:atom, 0, :get_module_info}
              },
              [{:atom, 0, Math}, {:var, 0, :Key}]
            }
          ]
        },
        {
          :clause,
          0,
          [{:match, 0, {:var, 0, :Key}, {:atom, 0, :compile}}],
          [],
          [
            {
              :call,
              0,
              {
                :remote,
                0,
                {:atom, 0, :erlang},
                {:atom, 0, :get_module_info}
              },
              [{:atom, 0, Math}, {:var, 0, :Key}]
            }
          ]
        },
        {
          :clause,
          0,
          [{:match, 0, {:var, 0, :Key}, {:atom, 0, :md5}}],
          [],
          [
            {
              :call,
              0,
              {
                :remote,
                0,
                {:atom, 0, :erlang},
                {:atom, 0, :get_module_info}
              },
              [{:atom, 0, Math}, {:var, 0, :Key}]
            }
          ]
        },
        {:clause, 0, [{:atom, 0, :deprecated}], [], [nil: 0]}
      ]
    },
    {
      :function,
      37,
      :add,
      1,
      [
        {
          :clause,
          37,
          [{:var, 37, :_nums@1}],
          [],
          [
            {
              :match,
              38,
              {
                :tuple,
                38,
                [{:var, 38, :_number_a@1}, {:var, 38, :_number_b@1}]
              },
              {:var, 38, :_nums@1}
            },
            {
              :call,
              39,
              {:atom, 39, :add},
              [{:var, 39, :_number_a@1}, {:var, 39, :_number_b@1}]
            }
          ]
        }
      ]
    },
    {
      :function,
      20,
      :add,
      2,
      [
        {
          :clause,
          20,
          [{:var, 20, :_number_a@1}, {:var, 20, :_number_b@1}],
          [],
          [
            {
              :op,
              21,
              :+,
              {:var, 21, :_number_a@1},
              {:var, 21, :_number_b@1}
            }
          ]
        }
      ]
    },
    {
      :function,
      50,
      :"MACRO-biggest",
      3,
      [
        {
          :clause,
          50,
          [{:var, 50, :_@CALLER}, {:var, 50, :_a@1}, {:var, 50, :_b@1}],
          [],
          [
            {
              :tuple,
              0,
              [
                {:atom, 0, :max},
                {
                  :cons,
                  0,
                  {:tuple, 0, [{:atom, 0, :context}, {:atom, 0, Math}]},
                  {
                    :cons,
                    0,
                    {
                      :tuple,
                      0,
                      [
                        {:atom, 0, :imports},
                        {
                          :cons,
                          0,
                          {
                            :tuple,
                            0,
                            [{:integer, 0, 2}, {:atom, 0, Kernel}]
                          },
                          {nil, 0}
                        }
                      ]
                    },
                    {nil, 0}
                  }
                },
                {
                  :cons,
                  0,
                  {:var, 52, :_a@1},
                  {:cons, 0, {:var, 52, :_b@1}, {nil, 0}}
                }
              ]
            }
          ]
        }
      ]
    },
    {
      :function,
      43,
      :divide,
      2,
      [
        {
          :clause,
          43,
          [{:var, 43, :_a@1}, {:var, 43, :_b@1}],
          [[{:op, 43, :"/=", {:var, 43, :_b@1}, {:integer, 43, 0}}]],
          [{:op, 44, :div, {:var, 44, :_a@1}, {:var, 44, :_b@1}}]
        }
      ]
    },
    {
      :function,
      28,
      :double,
      1,
      [
        {
          :clause,
          28,
          [{:var, 28, :_number@1}],
          [],
          [
            {
              :call,
              28,
              {:atom, 28, :add},
              [
                {
                  :tuple,
                  28,
                  [{:var, 28, :_number@1}, {:var, 28, :_number@1}]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      :function,
      56,
      :odd_or_even,
      1,
      [
        {
          :clause,
          56,
          [{:var, 56, :_a@1}],
          [],
          [
            {
              :case,
              57,
              {
                :op,
                57,
                :==,
                {:op, 57, :rem, {:var, 57, :_a@1}, {:integer, 57, 2}},
                {:integer, 57, 0}
              },
              [
                {
                  :clause,
                  [generated: true, location: 57],
                  [{:atom, [generated: true, location: 57], false}],
                  [],
                  [{:atom, [generated: true, location: 57], :odd}]
                },
                {
                  :clause,
                  [generated: true, location: 57],
                  [{:atom, [generated: true, location: 57], true}],
                  [],
                  [{:atom, [generated: true, location: 57], :even}]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      :function,
      64,
      :pi,
      0,
      [
        {
          :clause,
          64,
          [],
          [],
          [
            {
              :call,
              64,
              {:remote, 64, {:atom, 64, Math.Const}, {:atom, 64, :pi}},
              []
            }
          ]
        }
      ]
    },
    {
      :function,
      34,
      :triple,
      1,
      [
        {
          :clause,
          34,
          [{:var, 34, :_number@1}],
          [],
          [{:op, 34, :*, {:integer, 34, 3}, {:var, 34, :_number@1}}]
        }
      ]
    }
  ]
}

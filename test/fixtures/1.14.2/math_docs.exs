{
  :ok,
  {
    %{"en" => "Math is Fun"},
    %{},
    [
      {{:function, :add, 2}, 13, ["add(number_a, number_b)"], %{"en" => "Adds up two numbers."},
       %{}},
      {{:function, :divide, 2}, 34, ["divide(a, b)"], :none, %{}},
      {{:function, :double, 1}, 19, ["double(number)"], %{"en" => "Doubles a number."}, %{}},
      {{:function, :odd_or_even, 1}, 38, ["odd_or_even(a)"], :none, %{}},
      {{:function, :pi, 0}, 46, ["pi()"], :none, %{}},
      {{:function, :triple, 1}, 23, ["triple(number)"], %{"en" => "Triples a number."}, %{}},
      {{:type, :num, 0}, 6, [], :none, %{}},
      {{:type, :x, 0}, 7, [], :none, %{opaque: true}}
    ]
  }
}

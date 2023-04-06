{
  :ok,
  {
    %{"en" => "Math is Fun\n"},
    %{},
    [
      {{:function, :add, 2}, 16, ["add(number_a, number_b)"], %{"en" => "Adds up two numbers.\n"},
       %{}},
      {{:function, :divide, 2}, 43, ["divide(a, b)"], :none, %{}},
      {{:function, :double, 1}, 24, ["double(number)"], %{"en" => "Doubles a number.\n"}, %{}},
      {{:function, :odd_or_even, 1}, 56, ["odd_or_even(a)"], :none, %{}},
      {{:function, :pi, 0}, 64, ["pi()"], :none, %{}},
      {{:function, :triple, 1}, 30, ["triple(number)"], %{"en" => "Triples a number.\n"}, %{}},
      {{:macro, :biggest, 2}, 47, ["biggest(a, b)"], %{"en" => "Returns the biggest.\n"}, %{}},
      {{:type, :num, 0}, 8, [], %{"en" => "number"}, %{}},
      {{:type, :x, 0}, 10, [], :none, %{opaque: true}}
    ]
  }
}

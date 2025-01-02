{:ok,
 {%{"en" => "Math is Fun\n"},
  %{
    behaviours: [],
    source_annos: [{1, 1}],
    source_path: ~c"/Users/kruse/Projects/hrzndhrn/beam_file/test/fixtures/math.ex"
  },
  [
    {{:function, :add, 2}, 16, ["add(number_a, number_b)"], %{"en" => "Adds up two numbers.\n"},
     %{source_annos: [{20, 7}]}},
    {{:function, :divide, 2}, 43, ["divide(a, b)"], :none, %{source_annos: [{43, 7}]}},
    {{:function, :double, 1}, 24, ["double(number)"], %{"en" => "Doubles a number.\n"},
     %{source_annos: [{28, 7}]}},
    {{:function, :odd_or_even, 1}, 56, ["odd_or_even(a)"], :none, %{source_annos: [{56, 7}]}},
    {{:function, :pi, 0}, 64, ["pi()"], :none, %{source_annos: [{64, 7}]}},
    {{:function, :triple, 1}, 30, ["triple(number)"], %{"en" => "Triples a number.\n"},
     %{source_annos: [{34, 7}]}},
    {{:macro, :biggest, 2}, 47, ["biggest(a, b)"], %{"en" => "Returns the biggest.\n"},
     %{source_annos: [{50, 12}]}},
    {{:type, :num, 0}, 8, [], %{"en" => "number"}, %{source_annos: [{9, 9}]}},
    {{:type, :x, 0}, 10, [], :none, %{opaque: true, source_annos: [{10, 11}]}}
  ]}}

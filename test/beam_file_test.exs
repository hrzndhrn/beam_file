defmodule BeamFileTest do
  use ExUnit.Case

  @math_abstract_code Code.eval_file("test/fixtures/math_abstract_code.exs") |> elem(0)
  @math_debug_info Code.eval_file("test/fixtures/math_debug_info.exs") |> elem(0)
  @math_erl_code Code.eval_file("test/fixtures/math_erl_code.exs") |> elem(0)

  describe "which/1" do
    test "returns the path to the given module" do
      assert {:ok, path} = BeamFile.which(Math)
      assert path =~ "beam_file/_build/test/lib/beam_file/ebin/Elixir.Math.beam"
    end

    test "returns an error tuple" do
      assert BeamFile.which(Unknown.Module) == {:error, :non_existing}
    end
  end

  test "abstract_code/1" do
    assert BeamFile.abstract_code(Math) == @math_abstract_code
  end

  test "info/1" do
    info = BeamFile.info(Math)
    assert info[:file] =~ "_build/test/lib/beam_file/ebin/Elixir.Math.beam"
    assert info[:module] == Math

    assert info[:chunks] == [
             {'AtU8', 20, 209},
             {'Code', 240, 309},
             {'StrT', 560, 0},
             {'ImpT', 568, 88},
             {'ExpT', 664, 112},
             {'LitT', 784, 105},
             {'LocT', 900, 16},
             {'Attr', 924, 40},
             {'CInf', 972, 198},
             {'Dbgi', 1180, 925},
             {'Docs', 2116, 286},
             {'ExCk', 2412, 396},
             {'Line', 2816, 63}
           ]
  end

  test "chunks/1" do
    assert {:ok, _chunks} = BeamFile.chunks(Math)
  end

  describe "chunk/2" do
    test "Dbgi" do
      assert {:ok, _} = BeamFile.chunk(Math, 'Dbgi')
    end

    test ":debug_info" do
      assert BeamFile.chunk(Math, :debug_info) == @math_debug_info
    end
  end

  test "debug_info/1" do
    {:ok, {:debug_info_v1, _backend, {:elixir_v1, debug_info, data}}} = @math_debug_info
    assert BeamFile.debug_info(Math) == {:ok, {debug_info, data}}
  end

  test "erl_code/1" do
    assert BeamFile.erl_code(Math) == @math_erl_code
  end

  test "byte_code/1" do
    assert {:ok, byte_code} = BeamFile.byte_code(Math)
    assert elem(byte_code, 0) == :beam_file
    assert elem(byte_code, 1) == Math

    assert elem(byte_code, 2) == [
             {:__info__, 1, 2},
             {:add, 2, 11},
             {:divide, 2, 13},
             {:double, 1, 15},
             {:module_info, 0, 24},
             {:module_info, 1, 26},
             {:odd_or_even, 1, 17},
             {:pi, 0, 20},
             {:triple, 1, 22}
           ]

    assert elem(byte_code, 5) |> Enum.at(2) ==
             {:function, :add, 2, 11,
              [
                {:line, 2},
                {:label, 10},
                {:func_info, {:atom, Math}, {:atom, :add}, 2},
                {:label, 11},
                {:line, 3},
                {:gc_bif, :+, {:f, 0}, 2, [x: 0, x: 1], {:x, 0}},
                :return
              ]}
  end

  test "docs/1" do
    assert BeamFile.docs(Math) ==
             {:ok,
              {%{"en" => "Math is Fun"}, %{},
               [
                 {{:function, :add, 2}, 13, ["add(number_a, number_b)"],
                  %{"en" => "Adds up two numbers."}, %{}},
                 {{:function, :divide, 2}, 34, ["divide(a, b)"], :none, %{}},
                 {{:function, :double, 1}, 19, ["double(number)"], %{"en" => "Doubles a number."},
                  %{}},
                 {{:function, :odd_or_even, 1}, 38, ["odd_or_even(a)"], :none, %{}},
                 {{:function, :pi, 0}, 46, ["pi()"], :none, %{}},
                 {{:function, :triple, 1}, 23, ["triple(number)"], %{"en" => "Triples a number."},
                  %{}},
                 {{:type, :num, 0}, 6, [], :none, %{}},
                 {{:type, :x, 0}, 7, [], :none, %{opaque: true}}
               ]}}
  end

  describe "elixir_code/2" do
    test "returns elixir code for the Math module" do
      assert {:ok, code} = BeamFile.elixir_code(Math)
      assert code <> "\n" == File.read!("test/fixtures/math.exs")
    end

    test "returns elixir code for the Math module without docs" do
      assert {:ok, code} = BeamFile.elixir_code(Math, docs: false)
      assert code <> "\n" == File.read!("test/fixtures/math_without_docs.exs")
    end

    test "returns elixir code for the Default module" do
      assert {:ok, code} = BeamFile.elixir_code(Default)
      assert code <> "\n" == File.read!("test/fixtures/default.exs")
    end

    test "returns elixir code for the Delegate module" do
      assert {:ok, code} = BeamFile.elixir_code(Delegate)
      assert code <> "\n" == File.read!("test/fixtures/delegate.exs")
    end
  end
end

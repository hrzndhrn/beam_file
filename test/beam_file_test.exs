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

    assert [
             {'AtU8', _, _},
             {'Code', _, _},
             {'StrT', _, _},
             {'ImpT', _, _},
             {'ExpT', _, _},
             {'LitT', _, _},
             {'LocT', _, _},
             {'Attr', _, _},
             {'CInf', _, _},
             {'Dbgi', _, _},
             {'Docs', _, _},
             {'ExCk', _, _},
             {'Line', _, _}
           ] = info[:chunks]
  end

  test "chunks/1" do
    assert {:ok, _chunks} = BeamFile.chunks(Math)
  end

  describe "chunk/2" do
    test "Dbgi" do
      assert {:ok, _} = BeamFile.chunk(Math, 'Dbgi')
    end

    test ":debug_info" do
      {:ok, {:debug_info_v1, _backend, {:elixir_v1, expected_info, expected_data}}} =
        @math_debug_info

      assert {:ok, {:debug_info_v1, _backend, {:elixir_v1, info, data}}} =
               BeamFile.chunk(Math, :debug_info)

      assert data == expected_data

      keys = [:definitions, :module, :relative_file]
      assert Map.take(info, keys) == Map.take(expected_info, keys)
    end
  end

  test "debug_info/1" do
    {:ok, {:debug_info_v1, _backend, {:elixir_v1, expected_info, expected_data}}} =
      @math_debug_info

    assert {:ok, {info, data}} = BeamFile.debug_info(Math)
    assert data == expected_data

    keys = [:definitions, :module, :relative_file]
    assert Map.take(info, keys) == Map.take(expected_info, keys)
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
             {
               :ok,
               {
                 %{"en" => "Math is Fun"},
                 %{},
                 [
                   {
                     {:function, :add, 2},
                     13,
                     ["add(number_a, number_b)"],
                     %{"en" => "Adds up two numbers."},
                     %{}
                   },
                   {{:function, :divide, 2}, 34, ["divide(a, b)"], %{}, %{}},
                   {
                     {:function, :double, 1},
                     19,
                     ["double(number)"],
                     %{"en" => "Doubles a number."},
                     %{}
                   },
                   {{:function, :odd_or_even, 1}, 38, ["odd_or_even(a)"], %{}, %{}},
                   {{:function, :pi, 0}, 46, ["pi()"], %{}, %{}},
                   {
                     {:function, :triple, 1},
                     23,
                     ["triple(number)"],
                     %{"en" => "Triples a number."},
                     %{}
                   },
                   {{:type, :num, 0}, 6, [], %{}, %{}},
                   {{:type, :x, 0}, 7, [], %{}, %{opaque: true}}
                 ]
               }
             }
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

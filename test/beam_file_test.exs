defmodule BeamFileTest do
  use ExUnit.Case

  fixture = fn file, version ->
    "test/fixtures/#{version}/#{file}/" |> Code.eval_file() |> elem(0)
  end

  @math_abstract_code fixture.("math_abstract_code.exs", System.version())
  @math_debug_info fixture.("math_debug_info.exs", System.version())
  @math_erl_code fixture.("math_erl_code.exs", :erlang.system_info(:otp_release))
  @math_docs fixture.("math_docs.exs", System.version())

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

    assert elem(byte_code, 2) |> Enum.map(fn {key, _, _} -> key end) == [
             :__info__,
             :add,
             :divide,
             :double,
             :module_info,
             :module_info,
             :odd_or_even,
             :pi,
             :triple
           ]

    assert {:function, :add, _, _, _} = elem(byte_code, 5) |> Enum.at(2)
  end

  test "docs/1" do
    assert BeamFile.docs(Math) == @math_docs
  end

  describe "elixir_code/2" do
    test "returns elixir code for the Math module" do
      assert {:ok, code} = BeamFile.elixir_code(Math)
      assert code <> "\n" == File.read!("test/fixtures/#{System.version()}/math.exs")
    end

    test "returns elixir code for the Math module without docs" do
      assert {:ok, code} = BeamFile.elixir_code(Math, docs: false)
      assert code <> "\n" == File.read!("test/fixtures/#{System.version()}/math_without_docs.exs")
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

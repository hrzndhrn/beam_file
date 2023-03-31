defmodule BeamFileTest do
  use ExUnit.Case

  alias BeamFile.Error

  if System.version() =~ "1.13" and :erlang.system_info(:otp_release) == '25' do
    doctest(BeamFile)
  end

  @math_beam_path "_build/test/lib/beam_file/ebin/Elixir.Math.beam"
  @math_abstract_code TestSupport.fixture_version("math_abstract_code.exs")
  @math_debug_info TestSupport.fixture_version("math_debug_info.exs")
  @math_docs TestSupport.fixture_version("math_docs.exs")
  @math_erl_code TestSupport.fixture_version("math_erl_code.exs")

  describe "abstract_code/1" do
    test "returns abstract code for module" do
      assert BeamFile.abstract_code(Math) == @math_abstract_code
    end

    test "returns abstract code for binary" do
      math = File.read!(@math_beam_path)
      assert BeamFile.abstract_code(math) == @math_abstract_code
    end

    test "returns abstract code for the beam file at the given path" do
      path = String.to_charlist(@math_beam_path)
      assert BeamFile.abstract_code(path) == @math_abstract_code
    end

    test "returns an error for an unknown module" do
      assert BeamFile.abstract_code(Module.Unknown) == {:error, :non_existing}
    end

    test "returns an error for invalid binary" do
      assert BeamFile.abstract_code(<<42>>) == {:error, {:not_a_beam_file, "*"}}
    end

    test "returns an error for an invalid path" do
      assert BeamFile.abstract_code('invalid/path') ==
               {:error, {:file_error, 'invalid/path.beam', :enoent}}
    end
  end

  describe "abstract_code!/1" do
    test "returns abstract code for module" do
      {:ok, code} = @math_abstract_code
      assert BeamFile.abstract_code!(Math) == code
    end

    test "returns an error for an invalid path" do
      message = """
      Abstract code for 'invalid/path' not available, \
      reason: {:file_error, 'invalid/path.beam', :enoent}\
      """

      assert_raise Error, message, fn ->
        BeamFile.abstract_code!('invalid/path')
      end
    end
  end

  describe "all_chunks/2" do
    test "returns all chunks for a module with default type" do
      assert {:ok, _chunks} = BeamFile.all_chunks(Math)
    end

    test "returns all chunks for a module with type ids" do
      assert {:ok, _chunks} = BeamFile.all_chunks(Math, :ids)
    end

    test "returns an error tuple for an invalid module" do
      assert BeamFile.all_chunks(Unknown) == {:error, :non_existing}
    end

    test "returns an error tuple for an dynamic compiled module" do
      Code.compile_string("""
      defmodule OnTheFly do
      end
      """)

      assert BeamFile.all_chunks(OnTheFly) == {:error, :non_existing}
    end
  end

  describe "all_chunks!/2" do
    test "returns all chunks for a module with default type" do
      assert Math |> BeamFile.all_chunks!() |> is_map()
    end

    test "returns all chunks for a module with type ids" do
      assert Math |> BeamFile.all_chunks!(:ids) |> is_map()
    end

    test "returns an error tuple for an invalid module" do
      message = "Chunks for Unknown not available, reason: :non_existing"

      assert_raise Error, message, fn ->
        BeamFile.all_chunks!(Unknown) == {:error, :non_existing}
      end
    end
  end

  describe "byte_code/1" do
    test "returns the byte code for a module" do
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

    test "returns the byte code for binary" do
      binary = File.read!(@math_beam_path)

      assert {:ok, byte_code} = BeamFile.byte_code(binary)
      assert elem(byte_code, 0) == :beam_file
      assert elem(byte_code, 1) == Math
    end

    test "returns the byte code for the beam file at the given path" do
      path = String.to_charlist(@math_beam_path)

      assert {:ok, byte_code} = BeamFile.byte_code(path)
      assert elem(byte_code, 0) == :beam_file
      assert elem(byte_code, 1) == Math
    end

    test "returns an error for an unknown module" do
      assert BeamFile.byte_code(Unknown.Module) == {:error, :non_existing}
    end

    test "returns an error for invalid binary" do
      assert BeamFile.byte_code(<<42>>) == {:error, {:not_a_beam_file, "*"}}
    end

    test "returns an error for an invalid path" do
      assert BeamFile.byte_code('invalid/path') == {:error, :enoent}
    end
  end

  describe "byte_code!/1" do
    test "returns abstract code for module" do
      byte_code = BeamFile.byte_code!(Math)

      assert elem(byte_code, 0) == :beam_file
      assert elem(byte_code, 1) == Math
    end

    test "returns an error for invalid binary" do
      message = "Byte code for <<42>> not available, reason: {:not_a_beam_file, <<42>>}"

      assert_raise Error, message, fn ->
        BeamFile.byte_code!(<<42>>)
      end
    end
  end

  describe "chunk/2" do
    test "return chunk Dbgi for  a module" do
      assert {:ok, dbgi} = BeamFile.chunk(Math, 'Dbgi')
      assert is_binary(dbgi) == true
    end

    test "return chunk Dbgi for  a path" do
      path = String.to_charlist(@math_beam_path)
      assert {:ok, dbgi} = BeamFile.chunk(path, 'Dbgi')
      assert is_binary(dbgi) == true
    end

    test "return chunk Dbgi for  binary" do
      binary = File.read!(@math_beam_path)
      assert {:ok, dbgi} = BeamFile.chunk(binary, 'Dbgi')
      assert is_binary(dbgi) == true
    end

    test "return chunk :debug_info" do
      {:ok, {:debug_info_v1, _backend, {:elixir_v1, expected_info, expected_data}}} =
        @math_debug_info

      assert {:ok, {:debug_info_v1, _backend, {:elixir_v1, info, data}}} =
               BeamFile.chunk(Math, :debug_info)

      assert data == expected_data

      keys = [:definitions, :module, :relative_file]
      assert Map.take(info, keys) == Map.take(expected_info, keys)
    end

    test "returns chunks for :docs and 'Docs'" do
      assert {:ok, per_name} = BeamFile.chunk(Math, :docs)
      assert {:ok, per_id} = BeamFile.chunk(Math, 'Docs')
      assert per_name == :erlang.binary_to_term(per_id)
    end

    test "returns an error for an unknown module" do
      assert BeamFile.chunk(Unknown, :docs) == {:error, :non_existing}
    end
  end

  describe "chunk!/2" do
    test "return chunk Dbgi for  a module" do
      dbgi = BeamFile.chunk!(Math, 'Dbgi')
      assert is_binary(dbgi) == true
    end

    test "raises an error for invalid binary" do
      message = "Chunk :docs for <<55>> not available, reason: {:not_a_beam_file, <<55>>}"

      assert_raise Error, message, fn ->
        BeamFile.chunk!(<<55>>, :docs)
      end
    end
  end

  describe "debug_info/1" do
    test "return debug info for a module" do
      {:ok, {:debug_info_v1, _backend, {:elixir_v1, expected_info, _meta}}} = @math_debug_info

      assert {:ok, debug_info} = BeamFile.debug_info(Math)

      keys = [:definitions, :module, :relative_file]
      assert Map.take(debug_info, keys) == Map.take(expected_info, keys)
    end

    test "return debug info for a path" do
      path = String.to_charlist(@math_beam_path)
      assert {:ok, _info} = BeamFile.debug_info(path)
    end

    test "return debug info for binary" do
      binary = File.read!(@math_beam_path)
      assert {:ok, _info} = BeamFile.debug_info(binary)
    end

    test "returns an error for an invalid path" do
      assert BeamFile.debug_info('invalid/path') ==
               {:error, {:file_error, 'invalid/path.beam', :enoent}}
    end

    test "returns an error if no debug info is available" do
      code = """
      defmodule Foo do
        def foo, do: :foo
      end
      """

      Code.put_compiler_option(:debug_info, false)
      binary = code |> Code.compile_string() |> Keyword.fetch!(Foo)
      Code.put_compiler_option(:debug_info, true)

      assert BeamFile.debug_info(binary) == {:error, :no_debug_info}
    end
  end

  describe "debug_info!/1" do
    test "return debug info for a module" do
      {:ok, {:debug_info_v1, _backend, {:elixir_v1, expected_info, _meta}}} = @math_debug_info

      debug_info = BeamFile.debug_info!(Math)

      keys = [:definitions, :module, :relative_file]
      assert Map.take(debug_info, keys) == Map.take(expected_info, keys)
    end

    test "raises an exception for invalid binary" do
      message = "Debug info for <<77>> not available, reason: {:not_a_beam_file, <<77>>}"

      assert_raise Error, message, fn ->
        BeamFile.debug_info!(<<77>>)
      end
    end
  end

  describe "docs/1" do
    test "return docs info for a module" do
      assert BeamFile.docs(Math) == @math_docs
    end

    test "return docs info for a path" do
      path = String.to_charlist(@math_beam_path)
      assert BeamFile.docs(path) == @math_docs
    end

    test "return docs info for binary" do
      binary = File.read!(@math_beam_path)
      assert BeamFile.docs(binary) == @math_docs
    end

    test "returns an error for invalid binary" do
      assert BeamFile.docs(<<0, 0, 55>>) == {:error, {:not_a_beam_file, <<0, 0, 55>>}}
    end
  end

  describe "docs!/1" do
    test "returns docs info for a module" do
      {:ok, math_docs} = @math_docs
      assert BeamFile.docs!(Math) == math_docs
    end

    test "raises an error for an unknown module" do
      message = "Docs for Unknown not available, reason: :non_existing"

      assert_raise Error, message, fn ->
        BeamFile.docs!(Unknown)
      end
    end
  end

  describe "elixir_code/2" do
    test "returns elixir code for the Math module" do
      assert {:ok, code} = BeamFile.elixir_code(Math)
      assert code <> "\n" == File.read!("test/fixtures/#{TestSupport.system_version()}/math.exs")
    end

    test "returns elixir code for the Math module without docs" do
      assert {:ok, code} = BeamFile.elixir_code(Math, docs: false)

      assert code <> "\n" ==
               File.read!("test/fixtures/#{TestSupport.system_version()}/math_without_docs.exs")
    end

    test "returns elixir code for the Default module" do
      assert {:ok, code} = BeamFile.elixir_code(Default)
      assert code <> "\n" == File.read!("test/fixtures/default.exs")
    end

    test "returns elixir code for the Delegate module" do
      assert {:ok, code} = BeamFile.elixir_code(Delegate)
      assert code <> "\n" == File.read!("test/fixtures/delegate.exs")
    end

    test "returns an error for invalid binary" do
      assert BeamFile.elixir_code(<<0, 0, 7>>) == {:error, {:not_a_beam_file, <<0, 0, 7>>}}
    end
  end

  describe "elixir_code!/2" do
    test "returns elixir code for the Math module" do
      assert BeamFile.elixir_code!(Math) <> "\n" ==
               File.read!("test/fixtures/#{TestSupport.system_version()}/math.exs")
    end

    test "raises an error for an unknown module" do
      message = "Elixir code for Unknown not available, reason: :non_existing"

      assert_raise Error, message, fn ->
        BeamFile.elixir_code!(Unknown)
      end
    end
  end

  if :erlang.system_info(:otp_release) == '25' do
    describe "erl_code/1" do
      test "returns Erlang code for a module" do
        assert BeamFile.erl_code(Math) == @math_erl_code
      end

      test "returns an error for invalid binary" do
        assert BeamFile.erl_code(<<0, 42>>) == {:error, {:not_a_beam_file, <<0, 42>>}}
      end
    end

    describe "erl_code!/1" do
      test "returns Erlang code for a module" do
        {:ok, code} = @math_erl_code
        assert BeamFile.erl_code!(Math) == code
      end

      test "raises an error for invalid binary" do
        message = "Erlang code for <<77>> not available, reason: {:not_a_beam_file, <<77>>}"

        assert_raise Error, message, fn ->
          BeamFile.erl_code!(<<77>>)
        end
      end
    end
  else
    test "erl_code/1" do
      assert {:ok, _erl_code} = BeamFile.erl_code(Math)
    end

    test "erl_code!/1" do
      assert is_binary(BeamFile.erl_code!(Math))
    end
  end

  test "info/1" do
    {:ok, info} = BeamFile.info(Math)
    assert info[:file] =~ "_build/test/lib/beam_file/ebin/Elixir.Math.beam"
    assert info[:module] == Math

    if :erlang.system_info(:otp_release) == '25' do
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
               {'Line', _, _},
               {'Type', _, _}
             ] = info[:chunks]
    else
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
  end

  describe "info/1" do
    test "returns info for a module" do
      assert {:ok, info} = BeamFile.info(Math)
      assert info[:module] == Math
    end

    test "returns info for binary" do
      math = File.read!(@math_beam_path)
      assert {:ok, info} = BeamFile.info(math)
      assert info[:module] == Math
    end

    test "returns info for the beam file at the given path" do
      path = String.to_charlist(@math_beam_path)
      assert {:ok, info} = BeamFile.info(path)
      assert info[:module] == Math
    end

    test "returns an error tuple for an invalid path" do
      assert BeamFile.info('invalid/path') ==
               {:error, {:file_error, 'invalid/path.beam', :enoent}}
    end

    test "returns an error tuple for invalid binary" do
      assert BeamFile.info("invalid") == {:error, {:not_a_beam_file, "invalid"}}
    end
  end

  describe "read/1" do
    test "reads the binary for a module" do
      assert {:ok, binary} = BeamFile.read(Math)
      assert is_binary(binary)
    end

    test "binary stays binary :)" do
      assert BeamFile.read("ping") == {:ok, "ping"}
    end
  end

  describe "read!/1" do
    test "reads the binary for a module" do
      assert Math |> BeamFile.read!() |> is_binary()
    end

    test "raises an error for an unknown module" do
      message = "Can not read Unknown, reason: :non_existing"

      assert_raise Error, message, fn ->
        BeamFile.read!(Unknown)
      end
    end
  end

  describe "which/1" do
    test "returns the path to the given module" do
      assert {:ok, path} = BeamFile.which(Math)
      assert path =~ @math_beam_path
    end

    test "returns an error tuple" do
      assert BeamFile.which(Unknown.Module) == {:error, :non_existing}
    end

    test "returns an error tuple for an dynamic compiled module" do
      Code.compile_string("""
      defmodule OnTheFly do
      end
      """)

      assert BeamFile.which(OnTheFly) == {:error, :non_existing}
    end
  end

  describe "which!/1" do
    test "returns the path to the given module" do
      assert BeamFile.which!(Math) =~ "_build/test/lib/beam_file/ebin/Elixir.Math.beam"
    end

    test "raises an error" do
      message = "Path for Elixir.Unknown.Module not available, reason: :non_existing."

      assert_raise Error, message, fn ->
        BeamFile.which!(Unknown.Module)
      end
    end
  end
end

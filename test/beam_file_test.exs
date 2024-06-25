defmodule BeamFileTest do
  use ExUnit.Case

  alias BeamFile.Error

  if TestSupport.version?(:latest) and TestSupport.otp_release?(:latest) do
    doctest(BeamFile)
  end

  @math_beam_path "_build/test/lib/beam_file/ebin/Elixir.Math.beam"
  @math_abstract_code TestSupport.fixture("math_abstract_code.exs", eval: true)
  @math_debug_info TestSupport.fixture("math_debug_info.exs", eval: true)
  @math_docs TestSupport.fixture("math_docs.exs", eval: true)
  @math_with_docs TestSupport.fixture("math.exs")
  @math_without_docs TestSupport.fixture("math_without_docs.exs")

  @elixir_modules :elixir
                  |> Application.spec(:modules)
                  |> Enum.concat(Application.spec(:logger, :modules))
                  |> Enum.reject(fn
                    Kernel.SpecialForms -> true
                    :iex -> true
                    module -> module |> to_string() |> String.starts_with?("elixir")
                  end)

  describe "abstract_code/1" do
    test "returns abstract code for module" do
      if TestSupport.version?("~> 1.14") do
        if TestSupport.otp_release?(26) do
          assert BeamFile.abstract_code(Math) == @math_abstract_code
        else
          assert BeamFile.abstract_code(Math)
        end
      else
        assert BeamFile.abstract_code(Math) == @math_abstract_code
      end
    end

    test "returns abstract code for binary" do
      math = File.read!(@math_beam_path)

      if TestSupport.version?("~> 1.14") do
        if TestSupport.otp_release?(26) do
          assert BeamFile.abstract_code(math) == @math_abstract_code
        else
          assert BeamFile.abstract_code(math)
        end
      else
        assert BeamFile.abstract_code(math) == @math_abstract_code
      end
    end

    test "returns abstract code for the beam file at the given path" do
      path = String.to_charlist(@math_beam_path)

      if TestSupport.version?("~> 1.14") do
        if TestSupport.otp_release?(26) do
          assert BeamFile.abstract_code(path) == @math_abstract_code
        else
          assert BeamFile.abstract_code(path)
        end
      else
        assert BeamFile.abstract_code(path) == @math_abstract_code
      end
    end

    test "returns an error for an unknown module" do
      assert BeamFile.abstract_code(Module.Unknown) == {:error, :non_existing}
    end

    test "returns an error for invalid binary" do
      assert BeamFile.abstract_code(<<42>>) == {:error, {:not_a_beam_file, "*"}}
    end

    test "returns an error for an invalid path" do
      assert BeamFile.abstract_code(~c"invalid/path") == {:error, :enoent}
    end

    test "returns an error for an invalid charlist" do
      assert BeamFile.abstract_code([{1}]) == {:error, :invalid_input}
    end

    test "returns an error for an invalid input" do
      assert BeamFile.abstract_code(42) in [{:error, :invalid_input}, {:ok, {:none, %{}, []}}]
    end
  end

  describe "abstract_code!/1" do
    test "returns abstract code for module" do
      {:ok, code} = @math_abstract_code

      if TestSupport.version?("~> 1.14") do
        if TestSupport.otp_release?(26) do
          assert BeamFile.abstract_code!(Math) == code
        else
          assert BeamFile.abstract_code!(Math)
        end
      else
        assert BeamFile.abstract_code!(Math) == code
      end
    end

    test "returns an error for an invalid path" do
      message = """
      Abstract code for #{inspect(~c"invalid/path")} not available, reason: :enoent\
      """

      assert_raise Error, message, fn ->
        BeamFile.abstract_code!(~c"invalid/path")
      end
    end
  end

  describe "all_chunks/2" do
    test "returns all chunks for a module with default type" do
      assert {:ok, _chunks} = BeamFile.all_chunks(Math)
    end

    test "returns all chunks for a tuple with default type" do
      assert {:ok, _chunks} = BeamFile.all_chunks({:module, Math, BeamFile.binary!(Math), []})
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
               :"MACRO-biggest",
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

    test "returns the byte code for tuple" do
      assert {:ok, byte_code} = BeamFile.byte_code({:module, Math, BeamFile.binary!(Math), []})
      assert elem(byte_code, 0) == :beam_file
      assert elem(byte_code, 1) == Math
    end

    test "returns the byte code for the beam file at the given path" do
      path = String.to_charlist(@math_beam_path)

      assert {:ok, byte_code} = BeamFile.byte_code(path)
      assert elem(byte_code, 0) == :beam_file
      assert elem(byte_code, 1) == Math
    end

    test "returns an :beam_disasm error" do
      assert {:error, :invalid_input} = BeamFile.byte_code([{Foo, [55]}])
    end

    test "returns an error for an unknown module" do
      assert BeamFile.byte_code(Unknown.Module) == {:error, :non_existing}
    end

    test "returns an error for invalid binary" do
      assert BeamFile.byte_code(<<42>>) == {:error, {:beam_lib, {:not_a_beam_file, "*"}}}
    end

    test "returns an error for an invalid path" do
      assert BeamFile.byte_code(~c"invalid/path") == {:error, :enoent}
    end
  end

  describe "byte_code!/1" do
    test "returns abstract code for module" do
      byte_code = BeamFile.byte_code!(Math)

      assert elem(byte_code, 0) == :beam_file
      assert elem(byte_code, 1) == Math
    end

    test "returns an error for invalid binary" do
      message =
        "Byte code for <<42>> not available, reason: {:beam_lib, {:not_a_beam_file, <<42>>}}"

      assert_raise Error, message, fn ->
        BeamFile.byte_code!(<<42>>)
      end
    end
  end

  describe "chunk/2" do
    test "return chunk Dbgi for a module" do
      assert {:ok, dbgi} = BeamFile.chunk(Math, ~c"Dbgi")
      assert is_binary(dbgi) == true
    end

    test "return chunk Dbgi for a tuple" do
      assert {:ok, dbgi} = BeamFile.chunk({:module, Math, BeamFile.binary!(Math), []}, ~c"Dbgi")
      assert is_binary(dbgi) == true
    end

    test "return chunk Dbgi for  a path" do
      path = String.to_charlist(@math_beam_path)
      assert {:ok, dbgi} = BeamFile.chunk(path, ~c"Dbgi")
      assert is_binary(dbgi) == true
    end

    test "return chunk Dbgi for  binary" do
      binary = File.read!(@math_beam_path)
      assert {:ok, dbgi} = BeamFile.chunk(binary, ~c"Dbgi")
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
      assert {:ok, per_id} = BeamFile.chunk(Math, ~c"Docs")
      assert per_name == :erlang.binary_to_term(per_id)
    end

    test "returns an error for an unknown module" do
      assert BeamFile.chunk(Unknown, :docs) == {:error, :non_existing}
    end
  end

  describe "chunk!/2" do
    test "return chunk Dbgi for  a module" do
      dbgi = BeamFile.chunk!(Math, ~c"Dbgi")
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

    test "return debug info for tuple" do
      assert {:ok, _info} = BeamFile.debug_info({:module, Math, BeamFile.binary!(Math), []})
    end

    test "returns an error for an invalid path" do
      assert BeamFile.debug_info(~c"invalid/path") == {:error, :enoent}
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

    test "return docs info for tuple" do
      assert BeamFile.docs({:module, Math, BeamFile.binary!(Math), []}) == @math_docs
    end

    test "returns an error for invalid binary" do
      assert BeamFile.docs(<<0, 0, 55>>) == {:error, {:not_a_beam_file, <<0, 0, 55>>}}
    end

    test "returns an error for missing chunk" do
      [{_module, binary}] =
        Code.compile_string("""
        defmodule Foo do
        end
        """)

      assert BeamFile.docs(binary) in [{:ok, :missing_chunk}, {:ok, {:none, %{}, []}}]
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

  describe "docs!/2" do
    test "with format :info" do
      assert BeamFile.docs!(Math, format: :info) ==
               {[
                  {{:function, :add, 2}, [since: nil, hidden: false, deprecated: false]},
                  {{:function, :divide, 2}, [since: nil, hidden: false, deprecated: false]},
                  {{:function, :double, 1}, [since: nil, hidden: false, deprecated: false]},
                  {{:function, :odd_or_even, 1}, [since: nil, hidden: false, deprecated: false]},
                  {{:function, :pi, 0}, [since: nil, hidden: false, deprecated: false]},
                  {{:function, :triple, 1}, [since: nil, hidden: false, deprecated: false]},
                  {{:macro, :biggest, 2}, [since: nil, hidden: false, deprecated: false]},
                  {{:type, :num, 0}, [since: nil, hidden: false, deprecated: false]},
                  {{:type, :x, 0}, [since: nil, hidden: false, deprecated: false]}
                ], [since: nil, hidden: false, deprecated: false]}

      assert BeamFile.docs!(DocTags, format: :info) == {
               [
                 {{:function, :alpha, 0}, [since: nil, hidden: false, deprecated: false]},
                 {{:function, :bravo, 0}, [since: "1.2.0", hidden: false, deprecated: false]},
                 {{:function, :charlie, 0}, [since: "1.3.0", hidden: false, deprecated: false]},
                 {{:function, :delta, 0}, [since: "1.3.0", hidden: false, deprecated: true]},
                 {{:function, :echo, 0}, [since: "1.3.0", hidden: true, deprecated: true]},
                 {{:function, :foxtrot, 0}, [since: "1.3.0", hidden: false, deprecated: true]},
                 {{:type, :alpha, 0}, [since: "1.2.0", hidden: false, deprecated: false]}
               ],
               [since: "1.1.0", hidden: false, deprecated: false]
             }
    end

    test "with since" do
      assert BeamFile.docs!(DocTags, format: :since) ==
               {[
                  {{:function, :alpha, 0}, [since: nil]},
                  {{:function, :bravo, 0}, [since: "1.2.0"]},
                  {{:function, :charlie, 0}, [since: "1.3.0"]},
                  {{:function, :delta, 0}, [since: "1.3.0"]},
                  {{:function, :echo, 0}, [since: "1.3.0"]},
                  {{:function, :foxtrot, 0}, [since: "1.3.0"]},
                  {{:type, :alpha, 0}, [since: "1.2.0"]}
                ], [since: "1.1.0"]}

      assert BeamFile.docs!(DocTags, format: :since, since: "~> 1.0") ==
               {[
                  {{:function, :bravo, 0}, [since: "1.2.0"]},
                  {{:function, :charlie, 0}, [since: "1.3.0"]},
                  {{:function, :delta, 0}, [since: "1.3.0"]},
                  {{:function, :echo, 0}, [since: "1.3.0"]},
                  {{:function, :foxtrot, 0}, [since: "1.3.0"]},
                  {{:type, :alpha, 0}, [since: "1.2.0"]}
                ], [since: "1.1.0"]}

      assert BeamFile.docs!(DocTags, format: :since, since: "~> 1.1") ==
               BeamFile.docs!(DocTags, format: :since, since: "~> 1.2")

      assert BeamFile.docs!(DocTags, format: :since, since: "~> 1.3") ==
               {[
                  {{:function, :charlie, 0}, [since: "1.3.0"]},
                  {{:function, :delta, 0}, [since: "1.3.0"]},
                  {{:function, :echo, 0}, [since: "1.3.0"]},
                  {{:function, :foxtrot, 0}, [since: "1.3.0"]}
                ], [since: "1.1.0"]}

      assert BeamFile.docs!(DocTags, format: :since, since: "~> 1.4") == nil
    end

    test "with option hidden" do
      assert BeamFile.docs!(DocTags, format: :info, hidden: true) ==
               BeamFile.docs!(DocTags, format: :info)

      assert BeamFile.docs!(DocTags, format: :info, hidden: false) ==
               {[
                  {{:function, :alpha, 0}, [since: nil, hidden: false, deprecated: false]},
                  {{:function, :bravo, 0}, [since: "1.2.0", hidden: false, deprecated: false]},
                  {{:function, :charlie, 0}, [since: "1.3.0", hidden: false, deprecated: false]},
                  {{:function, :delta, 0}, [since: "1.3.0", hidden: false, deprecated: true]},
                  {{:function, :foxtrot, 0}, [since: "1.3.0", hidden: false, deprecated: true]},
                  {{:type, :alpha, 0}, [since: "1.2.0", hidden: false, deprecated: false]}
                ], [since: "1.1.0", hidden: false, deprecated: false]}
    end

    test "with option deprecated" do
      assert BeamFile.docs!(DocTags, format: :info, deprecated: true) ==
               {[
                  {{:function, :delta, 0}, [since: "1.3.0", hidden: false, deprecated: true]},
                  {{:function, :echo, 0}, [since: "1.3.0", hidden: true, deprecated: true]},
                  {{:function, :foxtrot, 0}, [since: "1.3.0", hidden: false, deprecated: true]}
                ], [since: "1.1.0", hidden: false, deprecated: false]}

      assert BeamFile.docs!(DocTags, format: :info, deprecated: false) ==
               {[
                  {{:function, :alpha, 0}, [since: nil, hidden: false, deprecated: false]},
                  {{:function, :bravo, 0}, [since: "1.2.0", hidden: false, deprecated: false]},
                  {{:function, :charlie, 0}, [since: "1.3.0", hidden: false, deprecated: false]},
                  {{:type, :alpha, 0}, [since: "1.2.0", hidden: false, deprecated: false]}
                ], [since: "1.1.0", hidden: false, deprecated: false]}

      assert {_doc, _meta, docs} = BeamFile.docs!(DocTags, deprecated: false)
      assert length(docs) == 4
    end
  end

  describe "elixir_code/2" do
    test "returns elixir code for the Math module" do
      assert {:ok, code} = BeamFile.elixir_code(Math)

      assert code <> "\n" == @math_without_docs
    end

    test "returns elixir code for the Math binary" do
      assert {:ok, code} = BeamFile.elixir_code(BeamFile.binary!(Math))

      assert code <> "\n" == @math_without_docs
    end

    test "returns elixir code for the Math tuple" do
      assert {:ok, code} = BeamFile.elixir_code({:module, Math, BeamFile.binary!(Math), []})

      assert code <> "\n" == @math_without_docs
    end

    test "returns elixir code for the Math module with docs" do
      assert {:ok, code} = BeamFile.elixir_code(Math, docs: true)

      assert code <> "\n" == @math_with_docs
    end

    test "returns elixir code for the Default module" do
      assert {:ok, code} = BeamFile.elixir_code(Default)
      assert code <> "\n" == File.read!("test/fixtures/default.exs")
    end

    test "returns elixir code for the Default module with docs" do
      assert {:ok, code} = BeamFile.elixir_code(Default, docs: true)
      assert code <> "\n" == File.read!("test/fixtures/default.exs")
    end

    test "returns elixir code for the Bodies module" do
      assert {:ok, code} = BeamFile.elixir_code(Bodies)
      assert code <> "\n" == File.read!("test/fixtures/bodies.exs")
    end

    test "returns elixir code for the Bodies module with docs" do
      assert {:ok, code} = BeamFile.elixir_code(Bodies, docs: true)
      assert code <> "\n" == File.read!("test/fixtures/bodies.exs")
    end

    test "returns elixir code for the Delegate module" do
      assert {:ok, code} = BeamFile.elixir_code(Delegate)
      assert code <> "\n" == File.read!("test/fixtures/delegate.exs")
    end

    test "returns elixir code with super" do
      assert {:ok, default} = BeamFile.elixir_code(DefaultMod)
      assert {:ok, inherit} = BeamFile.elixir_code(InheritMod)

      if TestSupport.version?("~> 1.14") do
        code = "#{default}\n\n#{inherit}"
        assert code <> "\n" == File.read!("test/fixtures/super.exs")
      end
    end

    if TestSupport.version?("~> 1.14") do
      test "returns elixir code with multiple whens" do
        assert {:ok, code} = BeamFile.elixir_code(MultiWhen)
        assert code <> "\n" == TestSupport.fixture("multi_when.exs")
      end
    end

    test "returns elixir code with op def" do
      assert {:ok, code} = BeamFile.elixir_code(Op)
      assert code <> "\n" == File.read!("test/fixtures/op.ex")
    end

    test "returns elixir code with ++" do
      assert {:ok, code} = BeamFile.elixir_code(PlusPlus)
      assert code <> "\n" == File.read!("test/fixtures/plus_plus.exs")
    end

    test "returns elixir code for DocDoc with docs" do
      assert {:ok, code} = BeamFile.elixir_code(DocDoc, docs: true)
      assert code <> "\n" == File.read!("test/fixtures/doc_doc.exs")
    end

    test "returns elixir code for the Comps module" do
      assert {:ok, code} = BeamFile.elixir_code(Comps)
      assert code <> "\n" == TestSupport.fixture("comps.exs")
    end

    test "returns an error for invalid binary" do
      assert BeamFile.elixir_code(<<0, 0, 7>>) == {:error, {:not_a_beam_file, <<0, 0, 7>>}}
    end

    for module <- @elixir_modules do
      test "returns elixir code for #{inspect(module)}" do
        assert {:ok, _code} = BeamFile.elixir_code(unquote(module))
      end

      test "returns elixir code for #{inspect(module)} with docs" do
        assert {:ok, _code} = BeamFile.elixir_code(unquote(module), docs: true)
      end
    end

    test "raises FunctionClauseError for Kernel.SpecialForms" do
      assert_raise FunctionClauseError, fn ->
        BeamFile.elixir_code(Kernel.SpecialForms)
      end
    end
  end

  describe "elixir_code!/2" do
    test "returns elixir code for the Math module" do
      assert BeamFile.elixir_code!(Math, docs: true) <> "\n" == @math_with_docs
    end

    test "returns elixir code for the Math binary" do
      assert code = BeamFile.elixir_code!(BeamFile.binary!(Math))

      assert code <> "\n" == @math_without_docs
    end

    test "returns elixir code for the Math tuple" do
      assert code = BeamFile.elixir_code!({:module, Math, BeamFile.binary!(Math), []})

      assert code <> "\n" == @math_without_docs
    end

    test "raises an error for an unknown module" do
      message = "Elixir code for Unknown not available, reason: :non_existing"

      assert_raise Error, message, fn ->
        BeamFile.elixir_code!(Unknown)
      end
    end
  end

  if TestSupport.version?(:latest, :latest) or
       TestSupport.version?("1.14.5", 25) or
       TestSupport.version?("1.13.4", 25) do
    @math_erl_code TestSupport.fixture("math.erl")

    describe "erl_code/1" do
      test "returns Erlang code for a module" do
        assert {:ok, code} = BeamFile.erl_code(Math)
        assert code <> "\n" == @math_erl_code
      end

      test "returns Erlang code for a tuple" do
        assert {:ok, code} = BeamFile.erl_code({:module, Math, BeamFile.binary!(Math), []})
        assert code <> "\n" == @math_erl_code
      end

      test "returns an error for invalid binary" do
        assert BeamFile.erl_code(<<0, 42>>) == {:error, {:not_a_beam_file, <<0, 42>>}}
      end
    end

    describe "erl_code!/1" do
      test "returns Erlang code for a module" do
        assert BeamFile.erl_code!(Math) <> "\n" == @math_erl_code
      end

      test "raises an error for invalid binary" do
        message = "Erlang code for <<77>> not available, reason: {:not_a_beam_file, <<77>>}"

        assert_raise Error, message, fn ->
          BeamFile.erl_code!(<<77>>)
        end
      end
    end
  else
    describe "erl_code/1" do
      test "returns Erlang code for a module" do
        assert {:ok, _code} = BeamFile.erl_code(Math)
      end

      test "returns Erlang code for a tuple" do
        assert {:ok, _code} = BeamFile.erl_code({:module, Math, BeamFile.binary!(Math), []})
      end
    end

    describe "erl_code!/1" do
      test "returns Erlang code for a module" do
        assert BeamFile.erl_code!(Math)
      end
    end
  end

  describe "info/1" do
    test "returns info for a module" do
      {:ok, info} = BeamFile.info(Math)
      assert info[:file] =~ "_build/test/lib/beam_file/ebin/Elixir.Math.beam"
      assert info[:module] == Math

      if TestSupport.otp_release?([25, 26, 27]) do
        assert [
                 {~c"AtU8", _, _},
                 {~c"Code", _, _},
                 {~c"StrT", _, _},
                 {~c"ImpT", _, _},
                 {~c"ExpT", _, _},
                 {~c"LitT", _, _},
                 {~c"LocT", _, _},
                 {~c"Attr", _, _},
                 {~c"CInf", _, _},
                 {~c"Dbgi", _, _},
                 {~c"Docs", _, _},
                 {~c"ExCk", _, _},
                 {~c"Line", _, _},
                 {~c"Type", _, _}
               ] = info[:chunks]
      else
        assert [
                 {~c"AtU8", _, _},
                 {~c"Code", _, _},
                 {~c"StrT", _, _},
                 {~c"ImpT", _, _},
                 {~c"ExpT", _, _},
                 {~c"LitT", _, _},
                 {~c"LocT", _, _},
                 {~c"Attr", _, _},
                 {~c"CInf", _, _},
                 {~c"Dbgi", _, _},
                 {~c"Docs", _, _},
                 {~c"ExCk", _, _},
                 {~c"Line", _, _}
               ] = info[:chunks]
      end
    end

    test "returns info for binary" do
      math = File.read!(@math_beam_path)
      assert {:ok, info} = BeamFile.info(math)
      assert info[:module] == Math
    end

    test "returns info for tuple" do
      assert {:ok, info} = BeamFile.info({:module, Math, BeamFile.binary!(Math), []})
      assert info[:module] == Math
    end

    test "returns info for the beam file at the given path" do
      path = String.to_charlist(@math_beam_path)
      assert {:ok, info} = BeamFile.info(path)
      assert info[:module] == Math
    end

    test "returns an error tuple for an invalid path" do
      assert BeamFile.info(~c"invalid/path") == {:error, :enoent}
    end

    test "returns an error tuple for invalid binary" do
      assert BeamFile.info("invalid") == {:error, {:not_a_beam_file, "invalid"}}
    end
  end

  describe "binary/1" do
    test "returns the binary for a module" do
      assert {:ok, binary} = BeamFile.binary(Math)
      assert is_binary(binary)
    end

    test "returns the binary for a module from the beam file" do
      assert {:ok, binary} = Math |> BeamFile.which!() |> BeamFile.binary()
      assert is_binary(binary)
    end

    test "binary stays binary :)" do
      assert BeamFile.binary("ping") == {:ok, "ping"}
    end
  end

  describe "binary!/1" do
    test "returns the binary for a module" do
      assert Math |> BeamFile.binary!() |> is_binary()
    end

    test "raises an error for an unknown module" do
      message = "Can not fetch Unknown, reason: :non_existing"

      assert_raise Error, message, fn ->
        BeamFile.binary!(Unknown)
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

  describe "elixir_quoted!/2" do
    test "returns the elixir ast for Math" do
      assert ast = BeamFile.elixir_quoted!(Math)

      assert Macro.to_string(ast) <> "\n" ==
               TestSupport.fixture("math_without_docs.exs")
    end

    test "returns the elixir ast for Comps" do
      assert quoted = BeamFile.elixir_quoted!(Comps)
      assert quoted == TestSupport.fixture("comps_ast.exs", eval: true)

      {:defmodule, meta, [_ | block]} = quoted

      assert [{TestComps, _bin}] =
               Code.compile_quoted(
                 {:defmodule, meta, [{:__aliases__, [alias: false], [TestComps]} | block]}
               )
    end

    test "returns the elixir ast for MultiWhen" do
      assert BeamFile.elixir_quoted!(MultiWhen)
    end

    test "returns the elixir ast for Op" do
      assert BeamFile.elixir_quoted!(Op)
    end

    test "returns the elixir ast for PlusPlus" do
      assert BeamFile.elixir_quoted!(PlusPlus)
    end

    test "returns the elixir ast for Kernel.SpecialForms" do
      assert BeamFile.elixir_quoted!(Kernel.SpecialForms)
    end

    test "raises an error for an unknown module" do
      message = "Elixir AST for Unknown not available, reason: :non_existing"

      assert_raise BeamFile.Error, message, fn ->
        BeamFile.elixir_quoted!(Unknown)
      end
    end
  end
end

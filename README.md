# BeamFile
[![Hex.pm](https://img.shields.io/hexpm/v/beam_file.svg)](https://hex.pm/packages/beam_file)
[![CI](https://github.com/hrzndhrn/beam_file/actions/workflows/elixir.yml/badge.svg)](https://github.com/hrzndhrn/beam_file/actions/workflows/elixir.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


A little fun project to get a peek into BEAM files. For now, this project is in
an early beta state.

BeamFile is mainly a wrapper around the Erlang module `:beam_lib`.

BeamFile provides different views to the data in a BEAM file:
- abstract code
- byte code
- Erlang code
- Elixir code.

The reconstructed Elixir code is not the original code. In this code all macros
and reference are resolved.

## Example

Assume we have an BEAM file compiled form the following source.
```elixir
defmodule Example.Math do
  @moduledoc "Math is Fun"

  def add(number_a, number_b), do: number_a + number_b

  def odd_or_even(a) do
    if rem(a, 2) == 0 do
      :even
    else
      :odd
    end
  end
end
```

Than we can reconstruct Elixir code:
```elixir
iex> {:ok, code} = BeamFile.elixir_code(Example.Math)
iex> IO.puts(code)
defmodule Elixir.Example.Math do
  @moduledoc """
  Math is Fun
  """

  def add(number_a, number_b) do
    :erlang.+(number_a, number_b)
  end

  def odd_or_even(a) do
    case(:erlang.==(:erlang.rem(a, 2), 0)) do
      false ->
        :odd

      true ->
        :even
    end
  end
end
```

Take a look on the Erlang code:
```elixir
iex> {:ok, code} = BeamFile.erl_code(Example.Math)
iex> IO.puts(code)
-file("test/fixtures/example/math.ex", 1).

-module('Elixir.Example.Math').

-compile([no_auto_import]).

-export(['__info__'/1, add/2, odd_or_even/1]).

-spec '__info__'(attributes | compile | functions |
                 macros | md5 | module | deprecated) -> any().

'__info__'(module) -> 'Elixir.Example.Math';
'__info__'(functions) -> [{add, 2}, {odd_or_even, 1}];
'__info__'(macros) -> [];
'__info__'(Key = attributes) ->
    erlang:get_module_info('Elixir.Example.Math', Key);
'__info__'(Key = compile) ->
    erlang:get_module_info('Elixir.Example.Math', Key);
'__info__'(Key = md5) ->
    erlang:get_module_info('Elixir.Example.Math', Key);
'__info__'(deprecated) -> [].

add(_number_a@1, _number_b@1) ->
    _number_a@1 + _number_b@1.

odd_or_even(_a@1) ->
    case _a@1 rem 2 == 0 of
      false -> odd;
      true -> even
    end.
```

Or byte code:
```elixir
iex> {:ok, code} = BeamFile.byte_code(Example.Math)
iex> IO.puts(code)
{:ok,
 {:beam_file, Example.Math,
  [
    {:__info__, 1, 2},
    {:add, 2, 8},
    {:module_info, 0, 13},
    {:module_info, 1, 15},
    {:odd_or_even, 1, 10}
  ], [vsn: [213009173131107396303781325243687557035]],
  [
    version: '7.5.3',
    options: [:no_spawn_compiler_process, :from_core,
     :no_auto_import],
    source: '/Users/kruse/Projects/beam_file/test/fixtures/example/math.ex'
  ],
  [
    {:function, :__info__, 1, 2,
     [
       {:label, 1},
       {:line, 0},
       {:func_info, {:atom, Example.Math}, {:atom, :__info__}, 1},
       {:label, 2},
       {:select_val, {:x, 0}, {:f, 1},
        {:list,
         [
           atom: :compile,
           f: 6,
           atom: :md5,
           f: 6,
           atom: :attributes,
           f: 6,
           atom: :functions,
           f: 5,
           atom: :macros,
           f: 4,
           atom: :deprecated,
           f: 4,
           atom: :module,
           f: 3
         ]}},
       {:label, 3},
       {:move, {:atom, Example.Math}, {:x, 0}},
       :return,
       {:label, 4},
       {:move, nil, {:x, 0}},
       :return,
       {:label, 5},
       {:move, {:literal, [add: 2, odd_or_even: 1]}, {:x, 0}},
       :return,
       {:label, 6},
       {:move, {:x, 0}, {:x, 1}},
       {:move, {:atom, Example.Math}, {:x, 0}},
       {:line, 0},
       {:call_ext_only, 2,
        {:extfunc, :erlang, :get_module_info, 2}}
     ]},
    {:function, :add, 2, 8,
     [
       {:line, 1},
       {:label, 7},
       {:func_info, {:atom, Example.Math}, {:atom, :add}, 2},
       {:label, 8},
       {:line, 1},
       {:gc_bif, :+, {:f, 0}, 2, [x: 0, x: 1], {:x, 0}},
       :return
     ]},
    {:function, :odd_or_even, 1, 10,
     [
       {:line, 2},
       {:label, 9},
       {:func_info, {:atom, Example.Math}, {:atom, :odd_or_even},
        1},
       {:label, 10},
       {:line, 3},
       {:gc_bif, :rem, {:f, 0}, 1, [x: 0, integer: 2], {:x, 0}},
       {:test, :is_eq_exact, {:f, 11}, [x: 0, integer: 0]},
       {:move, {:atom, :even}, {:x, 0}},
       :return,
       {:label, 11},
       {:move, {:atom, :odd}, {:x, 0}},
       :return
     ]},
    {:function, :module_info, 0, 13,
     [
       {:line, 0},
       {:label, 12},
       {:func_info, {:atom, Example.Math}, {:atom, :module_info},
        0},
       {:label, 13},
       {:move, {:atom, Example.Math}, {:x, 0}},
       {:line, 0},
       {:call_ext_only, 1,
        {:extfunc, :erlang, :get_module_info, 1}}
     ]},
    {:function, :module_info, 1, 15,
     [
       {:line, 0},
       {:label, 14},
       {:func_info, {:atom, Example.Math}, {:atom, :module_info},
        1},
       {:label, 15},
       {:move, {:x, 0}, {:x, 1}},
       {:move, {:atom, Example.Math}, {:x, 0}},
       {:line, 0},
       {:call_ext_only, 2,
        {:extfunc, :erlang, :get_module_info, 2}}
     ]}
  ]}}
```

## Resources

More information about BEAM files:

- [BEAM File Format](http://beam-wisdoms.clau.se/en/latest/indepth-beam-file.html)
  on [BEAM Wisdom](http://beam-wisdoms.clau.se/en/latest/)
- [The Feature That No One Knew About in Elixir 1.5](https://www.youtube.com/watch?time_continue=931&v=p4uE-jTB_Uk&feature=emb_logo)
  by José Valim
- [Disassemble Elixir code. And check if Erlang dead code elimination works](
https://medium.com/learn-elixir/disassemble-elixir-code-1bca5fe15dd1)
  by Gaspar Chilingarov

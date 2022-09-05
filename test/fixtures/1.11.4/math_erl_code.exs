{:ok,
 String.trim(~S"""
 -file("test/fixtures/math.ex", 1).

 -module('Elixir.Math').

 -compile([no_auto_import]).

 -spec triple(num()) -> x().

 -spec double(num()) -> x().

 -spec divide(num(), num()) -> x().

 -spec add(num() | num_tuple(), num()) -> x().

 -spec add(num_tuple()) -> x().

 -type num_tuple() :: {num(), num()}.

 -export_type([x/0]).

 -opaque x() :: num().

 -export_type([num/0]).

 -type num() :: integer().

 -export(['__info__'/1,
          add/2,
          divide/2,
          double/1,
          odd_or_even/1,
          pi/0,
          triple/1]).

 -spec '__info__'(attributes |
                  compile |
                  functions |
                  macros |
                  md5 |
                  exports_md5 |
                  module |
                  deprecated) -> any().

 '__info__'(module) -> 'Elixir.Math';
 '__info__'(functions) ->
     [{add, 2},
      {divide, 2},
      {double, 1},
      {odd_or_even, 1},
      {pi, 0},
      {triple, 1}];
 '__info__'(macros) -> [];
 '__info__'(exports_md5) ->
     <<"\031\2270d¿\023þ\000êãË\003ÑM,Þ">>;
 '__info__'(Key = attributes) ->
     erlang:get_module_info('Elixir.Math', Key);
 '__info__'(Key = compile) ->
     erlang:get_module_info('Elixir.Math', Key);
 '__info__'(Key = md5) ->
     erlang:get_module_info('Elixir.Math', Key);
 '__info__'(deprecated) -> [].

 add(_nums@1) ->
     {_number_a@1, _number_b@1} = _nums@1,
     add(_number_a@1, _number_b@1).

 add(_number_a@1, _number_b@1) ->
     _number_a@1 + _number_b@1.

 divide(_a@1, _b@1) when _b@1 /= 0 -> _a@1 div _b@1.

 double(_number@1) -> add({_number@1, _number@1}).

 odd_or_even(_a@1) ->
     case _a@1 rem 2 == 0 of
         false -> odd;
         true -> even
     end.

 pi() -> 'Elixir.Math.Const':pi().

 triple(_number@1) -> 3 * _number@1.
 """)}

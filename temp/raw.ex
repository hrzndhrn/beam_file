defmodule Elixir.Float do
  @moduledoc """
Functions for working with floating-point numbers.

## Kernel functions

There are functions related to floating-point numbers on the `Kernel` module
too. Here is a list of them:

  * `Kernel.round/1`: rounds a number to the nearest integer.
  * `Kernel.trunc/1`: returns the integer part of a number.

## Known issues

There are some very well known problems with floating-point numbers
and arithmetics due to the fact most decimal fractions cannot be
represented by a floating-point binary and most operations are not exact,
but operate on approximations. Those issues are not specific
to Elixir, they are a property of floating point representation itself.

For example, the numbers 0.1 and 0.01 are two of them, what means the result
of squaring 0.1 does not give 0.01 neither the closest representable. Here is
what happens in this case:

  * The closest representable number to 0.1 is 0.1000000014
  * The closest representable number to 0.01 is 0.0099999997
  * Doing 0.1 * 0.1 should return 0.01, but because 0.1 is actually 0.1000000014,
    the result is 0.010000000000000002, and because this is not the closest
    representable number to 0.01, you'll get the wrong result for this operation

There are also other known problems like flooring or rounding numbers. See
`round/2` and `floor/2` for more details about them.

To learn more about floating-point arithmetic visit:

  * [0.30000000000000004.com](http://0.30000000000000004.com/)
  * [What Every Programmer Should Know About Floating-Point Arithmetic](https://floating-point-gui.de/)


"""


@doc """
Parses a binary into a float.

If successful, returns a tuple in the form of `{float, remainder_of_binary}`;
when the binary cannot be coerced into a valid float, the atom `:error` is
returned.

If the size of float exceeds the maximum size of `1.7976931348623157e+308`,
the `ArgumentError` exception is raised.

If you want to convert a string-formatted float directly to a float,
`String.to_float/1` can be used instead.

## Examples

    iex> Float.parse("34")
    {34.0, ""}
    iex> Float.parse("34.25")
    {34.25, ""}
    iex> Float.parse("56.5xyz")
    {56.5, "xyz"}

    iex> Float.parse("pi")
    :error


"""
def parse(<<"-"::binary(), binary::binary()>>) do
case(parse_unsigned(binary)) do
  :error ->
    :error
  {number, remainder} ->
    {:erlang.-(number), remainder}
end
end

def parse(<<"+"::binary(), binary::binary()>>) do
parse_unsigned(binary)
end

def parse(binary) do
parse_unsigned(binary)
end

defp parse_unsigned(<<digit::integer(), rest::binary()>>)  when :erlang.andalso(:erlang.is_integer(digit), :erlang.andalso(:erlang.>=(digit, 48), :erlang."=<"(digit, 57))) do
parse_unsigned(rest, false, false, <<digit::integer()>>)
end

defp parse_unsigned(binary)  when :erlang.is_binary(binary) do
:error
end

defp parse_unsigned(<<digit::integer(), rest::binary()>>, dot?, e?, acc)  when :erlang.andalso(:erlang.is_integer(digit), :erlang.andalso(:erlang.>=(digit, 48), :erlang."=<"(digit, 57))) do
parse_unsigned(rest, dot?, e?, <<acc::binary(), digit::integer()>>)
end

defp parse_unsigned(<<46::integer(), digit::integer(), rest::binary()>>, false, false, acc)  when :erlang.andalso(:erlang.is_integer(digit), :erlang.andalso(:erlang.>=(digit, 48), :erlang."=<"(digit, 57))) do
parse_unsigned(rest, true, false, <<acc::binary(), 46::integer(), digit::integer()>>)
end

defp parse_unsigned(<<exp_marker::integer(), digit::integer(), rest::binary()>>, dot?, false, acc)  when :erlang.andalso(:erlang.orelse(:erlang."=:="(exp_marker, 101), :erlang."=:="(exp_marker, 69)), :erlang.andalso(:erlang.is_integer(digit), :erlang.andalso(:erlang.>=(digit, 48), :erlang."=<"(digit, 57)))) do
parse_unsigned(rest, true, true, <<add_dot(acc, dot?)::binary(), 101::integer(), digit::integer()>>)
end

defp parse_unsigned(<<exp_marker::integer(), sign::integer(), digit::integer(), rest::binary()>>, dot?, false, acc)  when :erlang.andalso(:erlang.andalso(:erlang.orelse(:erlang."=:="(exp_marker, 101), :erlang."=:="(exp_marker, 69)), :erlang.orelse(:erlang."=:="(sign, 45), :erlang."=:="(sign, 43))), :erlang.andalso(:erlang.is_integer(digit), :erlang.andalso(:erlang.>=(digit, 48), :erlang."=<"(digit, 57)))) do
parse_unsigned(rest, true, true, <<add_dot(acc, dot?)::binary(), 101::integer(), sign::integer(), digit::integer()>>)
end

defp parse_unsigned(rest, dot?, _e?, acc) do
{:erlang.binary_to_float(add_dot(acc, dot?)), rest}
end

defp add_dot(acc, true) do
acc
end

defp add_dot(acc, false) do
<<acc::binary(), ".0"::binary()>>
end

@doc """
Rounds a float to the largest number less than or equal to `num`.

`floor/2` also accepts a precision to round a floating-point value down
to an arbitrary number of fractional digits (between 0 and 15).
The operation is performed on the binary floating point, without a
conversion to decimal.

This function always returns a float. `Kernel.trunc/1` may be used instead to
truncate the result to an integer afterwards.

## Known issues

The behaviour of `floor/2` for floats can be surprising. For example:

    iex> Float.floor(12.52, 2)
    12.51

One may have expected it to floor to 12.52. This is not a bug.
Most decimal fractions cannot be represented as a binary floating point
and therefore the number above is internally represented as 12.51999999,
which explains the behaviour above.

## Examples

    iex> Float.floor(34.25)
    34.0
    iex> Float.floor(-56.5)
    -57.0
    iex> Float.floor(34.259, 2)
    34.25


"""
def floor(x0) do
floor(x0, 0)
end

def floor(number, 0)  when :erlang.is_float(number) do
:math.floor(number)
end

def floor(number, precision)  when :erlang.andalso(:erlang.is_float(number), :erlang.andalso(:erlang.is_integer(precision), :erlang.andalso(:erlang.>=(precision, 0), :erlang."=<"(precision, 15)))) do
round(number, precision, :floor)
end

def floor(number, precision)  when :erlang.is_float(number) do
:erlang.error(ArgumentError.exception(invalid_precision_message(precision)))
end

@doc """
Rounds a float to the smallest integer greater than or equal to `num`.

`ceil/2` also accepts a precision to round a floating-point value down
to an arbitrary number of fractional digits (between 0 and 15).

The operation is performed on the binary floating point, without a
conversion to decimal.

The behaviour of `ceil/2` for floats can be surprising. For example:

    iex> Float.ceil(-12.52, 2)
    -12.51

One may have expected it to ceil to -12.52. This is not a bug.
Most decimal fractions cannot be represented as a binary floating point
and therefore the number above is internally represented as -12.51999999,
which explains the behaviour above.

This function always returns floats. `Kernel.trunc/1` may be used instead to
truncate the result to an integer afterwards.

## Examples

    iex> Float.ceil(34.25)
    35.0
    iex> Float.ceil(-56.5)
    -56.0
    iex> Float.ceil(34.251, 2)
    34.26


"""
def ceil(x0) do
ceil(x0, 0)
end

def ceil(number, 0)  when :erlang.is_float(number) do
:math.ceil(number)
end

def ceil(number, precision)  when :erlang.andalso(:erlang.is_float(number), :erlang.andalso(:erlang.is_integer(precision), :erlang.andalso(:erlang.>=(precision, 0), :erlang."=<"(precision, 15)))) do
round(number, precision, :ceil)
end

def ceil(number, precision)  when :erlang.is_float(number) do
:erlang.error(ArgumentError.exception(invalid_precision_message(precision)))
end

@doc """
Rounds a floating-point value to an arbitrary number of fractional
digits (between 0 and 15).

The rounding direction always ties to half up. The operation is
performed on the binary floating point, without a conversion to decimal.

This function only accepts floats and always returns a float. Use
`Kernel.round/1` if you want a function that accepts both floats
and integers and always returns an integer.

## Known issues

The behaviour of `round/2` for floats can be surprising. For example:

    iex> Float.round(5.5675, 3)
    5.567

One may have expected it to round to the half up 5.568. This is not a bug.
Most decimal fractions cannot be represented as a binary floating point
and therefore the number above is internally represented as 5.567499999,
which explains the behaviour above. If you want exact rounding for decimals,
you must use a decimal library. The behaviour above is also in accordance
to reference implementations, such as "Correctly Rounded Binary-Decimal and
Decimal-Binary Conversions" by David M. Gay.

## Examples

    iex> Float.round(12.5)
    13.0
    iex> Float.round(5.5674, 3)
    5.567
    iex> Float.round(5.5675, 3)
    5.567
    iex> Float.round(-5.5674, 3)
    -5.567
    iex> Float.round(-5.5675)
    -6.0
    iex> Float.round(12.341444444444441, 15)
    12.341444444444441


"""
def round(x0) do
round(x0, 0)
end

def round(float, 0)  when :erlang.is_float(float) do
:erlang.float(:erlang.round(float))
end

def round(float, precision)  when :erlang.andalso(:erlang.is_float(float), :erlang.andalso(:erlang.is_integer(precision), :erlang.andalso(:erlang.>=(precision, 0), :erlang."=<"(precision, 15)))) do
round(float, precision, :half_up)
end

def round(float, precision)  when :erlang.is_float(float) do
:erlang.error(ArgumentError.exception(invalid_precision_message(precision)))
end

defp round(0.0, _precision, _rounding) do
0.0
end

defp round(float, precision, rounding) do
<<sign::integer()-size(1), exp::integer()-size(11), significant::bitstring()-size(52)>> = <<float::float()>>
{num, count, _} = decompose(significant, 1)
count = :erlang.+(:erlang.-(count, exp), 1023)
cond do
  :erlang.>=(count, 104) ->
    case(rounding) do
      :ceil when :erlang."=:="(sign, 0) ->
        :erlang./(1, power_of_10(precision))
      :floor when :erlang."=:="(sign, 1) ->
        :erlang./(:erlang.-(1), power_of_10(precision))
      _ ->
        0.0
    end
  :erlang."=<"(count, precision) ->
    float
  true ->
    diff = :erlang.-(:erlang.-(count, precision), 1)
    power_of_10 = power_of_10(diff)
    num = :erlang.*(num, power_of_5(count))
    num = :erlang.div(num, power_of_10)
    div = :erlang.div(num, 10)
    num = rounding(rounding, sign, num, div)
    den = power_of_10(precision)
    boundary = :erlang.bsl(den, 52)
    cond do
      :erlang.==(num, 0) ->
        0.0
      :erlang.>=(num, boundary) ->
        {den, exp} = scale_down(num, boundary, 52)
        decimal_to_float(sign, num, den, exp)
      true ->
        {num, exp} = scale_up(num, boundary, 52)
        decimal_to_float(sign, num, den, exp)
    end
end
end

defp scale_up(num, boundary, exp)  when :erlang.>=(num, boundary) do
{num, exp}
end

defp scale_up(num, boundary, exp) do
scale_up(:erlang.bsl(num, 1), boundary, :erlang.-(exp, 1))
end

defp scale_down(num, den, exp) do
new_den = :erlang.bsl(den, 1)
case(:erlang.<(num, new_den)) do
  false ->
    scale_down(num, new_den, :erlang.+(exp, 1))
  true ->
    {:erlang.bsr(den, 52), exp}
end
end

defp decimal_to_float(sign, num, den, exp) do
quo = :erlang.div(num, den)
rem = :erlang.-(num, :erlang.*(quo, den))
tmp = case(:erlang.bsr(den, 1)) do
  den when :erlang.>(rem, den) ->
    :erlang.+(quo, 1)
  den when :erlang.<(rem, den) ->
    quo
  _ when :erlang."=:="(:erlang.band(quo, 1), 1) ->
    :erlang.+(quo, 1)
  _ ->
    quo
end
tmp = :erlang.-(tmp, 4503599627370496)
<<tmp::float()>> = <<sign::integer()-size(1), :erlang.+(exp, 1023)::integer()-size(11), tmp::integer()-size(52)>>
tmp
end

defp rounding(:floor, 1, _num, div) do
:erlang.+(div, 1)
end

defp rounding(:ceil, 0, _num, div) do
:erlang.+(div, 1)
end

defp rounding(:half_up, _sign, num, div) do
case(:erlang.rem(num, 10)) do
  rem when :erlang.<(rem, 5) ->
    div
  rem when :erlang.>=(rem, 5) ->
    :erlang.+(div, 1)
end
end

defp rounding(_, _, _, div) do
div
end

defp power_of_10(0) do
1
end

defp power_of_10(1) do
10
end

defp power_of_10(2) do
100
end

defp power_of_10(3) do
1000
end

defp power_of_10(4) do
10000
end

defp power_of_10(5) do
100000
end

defp power_of_10(6) do
1000000
end

defp power_of_10(7) do
10000000
end

defp power_of_10(8) do
100000000
end

defp power_of_10(9) do
1000000000
end

defp power_of_10(10) do
10000000000
end

defp power_of_10(11) do
100000000000
end

defp power_of_10(12) do
1000000000000
end

defp power_of_10(13) do
10000000000000
end

defp power_of_10(14) do
100000000000000
end

defp power_of_10(15) do
1000000000000000
end

defp power_of_10(16) do
10000000000000000
end

defp power_of_10(17) do
100000000000000000
end

defp power_of_10(18) do
1000000000000000000
end

defp power_of_10(19) do
10000000000000000000
end

defp power_of_10(20) do
100000000000000000000
end

defp power_of_10(21) do
1000000000000000000000
end

defp power_of_10(22) do
10000000000000000000000
end

defp power_of_10(23) do
100000000000000000000000
end

defp power_of_10(24) do
1000000000000000000000000
end

defp power_of_10(25) do
10000000000000000000000000
end

defp power_of_10(26) do
100000000000000000000000000
end

defp power_of_10(27) do
1000000000000000000000000000
end

defp power_of_10(28) do
10000000000000000000000000000
end

defp power_of_10(29) do
100000000000000000000000000000
end

defp power_of_10(30) do
1000000000000000000000000000000
end

defp power_of_10(31) do
10000000000000000000000000000000
end

defp power_of_10(32) do
100000000000000000000000000000000
end

defp power_of_10(33) do
1000000000000000000000000000000000
end

defp power_of_10(34) do
10000000000000000000000000000000000
end

defp power_of_10(35) do
100000000000000000000000000000000000
end

defp power_of_10(36) do
1000000000000000000000000000000000000
end

defp power_of_10(37) do
10000000000000000000000000000000000000
end

defp power_of_10(38) do
100000000000000000000000000000000000000
end

defp power_of_10(39) do
1000000000000000000000000000000000000000
end

defp power_of_10(40) do
10000000000000000000000000000000000000000
end

defp power_of_10(41) do
100000000000000000000000000000000000000000
end

defp power_of_10(42) do
1000000000000000000000000000000000000000000
end

defp power_of_10(43) do
10000000000000000000000000000000000000000000
end

defp power_of_10(44) do
100000000000000000000000000000000000000000000
end

defp power_of_10(45) do
1000000000000000000000000000000000000000000000
end

defp power_of_10(46) do
10000000000000000000000000000000000000000000000
end

defp power_of_10(47) do
100000000000000000000000000000000000000000000000
end

defp power_of_10(48) do
1000000000000000000000000000000000000000000000000
end

defp power_of_10(49) do
10000000000000000000000000000000000000000000000000
end

defp power_of_10(50) do
100000000000000000000000000000000000000000000000000
end

defp power_of_10(51) do
1000000000000000000000000000000000000000000000000000
end

defp power_of_10(52) do
10000000000000000000000000000000000000000000000000000
end

defp power_of_10(53) do
100000000000000000000000000000000000000000000000000000
end

defp power_of_10(54) do
1000000000000000000000000000000000000000000000000000000
end

defp power_of_10(55) do
10000000000000000000000000000000000000000000000000000000
end

defp power_of_10(56) do
100000000000000000000000000000000000000000000000000000000
end

defp power_of_10(57) do
1000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(58) do
10000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(59) do
100000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(60) do
1000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(61) do
10000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(62) do
100000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(63) do
1000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(64) do
10000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(65) do
100000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(66) do
1000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(67) do
10000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(68) do
100000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(69) do
1000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(70) do
10000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(71) do
100000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(72) do
1000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(73) do
10000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(74) do
100000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(75) do
1000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(76) do
10000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(77) do
100000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(78) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(79) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(80) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(81) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(82) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(83) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(84) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(85) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(86) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(87) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(88) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(89) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(90) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(91) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(92) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(93) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(94) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(95) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(96) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(97) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(98) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(99) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(100) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(101) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(102) do
1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(103) do
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_10(104) do
100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
end

defp power_of_5(0) do
1
end

defp power_of_5(1) do
5
end

defp power_of_5(2) do
25
end

defp power_of_5(3) do
125
end

defp power_of_5(4) do
625
end

defp power_of_5(5) do
3125
end

defp power_of_5(6) do
15625
end

defp power_of_5(7) do
78125
end

defp power_of_5(8) do
390625
end

defp power_of_5(9) do
1953125
end

defp power_of_5(10) do
9765625
end

defp power_of_5(11) do
48828125
end

defp power_of_5(12) do
244140625
end

defp power_of_5(13) do
1220703125
end

defp power_of_5(14) do
6103515625
end

defp power_of_5(15) do
30517578125
end

defp power_of_5(16) do
152587890625
end

defp power_of_5(17) do
762939453125
end

defp power_of_5(18) do
3814697265625
end

defp power_of_5(19) do
19073486328125
end

defp power_of_5(20) do
95367431640625
end

defp power_of_5(21) do
476837158203125
end

defp power_of_5(22) do
2384185791015625
end

defp power_of_5(23) do
11920928955078125
end

defp power_of_5(24) do
59604644775390625
end

defp power_of_5(25) do
298023223876953125
end

defp power_of_5(26) do
1490116119384765625
end

defp power_of_5(27) do
7450580596923828125
end

defp power_of_5(28) do
37252902984619140625
end

defp power_of_5(29) do
186264514923095703125
end

defp power_of_5(30) do
931322574615478515625
end

defp power_of_5(31) do
4656612873077392578125
end

defp power_of_5(32) do
23283064365386962890625
end

defp power_of_5(33) do
116415321826934814453125
end

defp power_of_5(34) do
582076609134674072265625
end

defp power_of_5(35) do
2910383045673370361328125
end

defp power_of_5(36) do
14551915228366851806640625
end

defp power_of_5(37) do
72759576141834259033203125
end

defp power_of_5(38) do
363797880709171295166015625
end

defp power_of_5(39) do
1818989403545856475830078125
end

defp power_of_5(40) do
9094947017729282379150390625
end

defp power_of_5(41) do
45474735088646411895751953125
end

defp power_of_5(42) do
227373675443232059478759765625
end

defp power_of_5(43) do
1136868377216160297393798828125
end

defp power_of_5(44) do
5684341886080801486968994140625
end

defp power_of_5(45) do
28421709430404007434844970703125
end

defp power_of_5(46) do
142108547152020037174224853515625
end

defp power_of_5(47) do
710542735760100185871124267578125
end

defp power_of_5(48) do
3552713678800500929355621337890625
end

defp power_of_5(49) do
17763568394002504646778106689453125
end

defp power_of_5(50) do
88817841970012523233890533447265625
end

defp power_of_5(51) do
444089209850062616169452667236328125
end

defp power_of_5(52) do
2220446049250313080847263336181640625
end

defp power_of_5(53) do
11102230246251565404236316680908203125
end

defp power_of_5(54) do
55511151231257827021181583404541015625
end

defp power_of_5(55) do
277555756156289135105907917022705078125
end

defp power_of_5(56) do
1387778780781445675529539585113525390625
end

defp power_of_5(57) do
6938893903907228377647697925567626953125
end

defp power_of_5(58) do
34694469519536141888238489627838134765625
end

defp power_of_5(59) do
173472347597680709441192448139190673828125
end

defp power_of_5(60) do
867361737988403547205962240695953369140625
end

defp power_of_5(61) do
4336808689942017736029811203479766845703125
end

defp power_of_5(62) do
21684043449710088680149056017398834228515625
end

defp power_of_5(63) do
108420217248550443400745280086994171142578125
end

defp power_of_5(64) do
542101086242752217003726400434970855712890625
end

defp power_of_5(65) do
2710505431213761085018632002174854278564453125
end

defp power_of_5(66) do
13552527156068805425093160010874271392822265625
end

defp power_of_5(67) do
67762635780344027125465800054371356964111328125
end

defp power_of_5(68) do
338813178901720135627329000271856784820556640625
end

defp power_of_5(69) do
1694065894508600678136645001359283924102783203125
end

defp power_of_5(70) do
8470329472543003390683225006796419620513916015625
end

defp power_of_5(71) do
42351647362715016953416125033982098102569580078125
end

defp power_of_5(72) do
211758236813575084767080625169910490512847900390625
end

defp power_of_5(73) do
1058791184067875423835403125849552452564239501953125
end

defp power_of_5(74) do
5293955920339377119177015629247762262821197509765625
end

defp power_of_5(75) do
26469779601696885595885078146238811314105987548828125
end

defp power_of_5(76) do
132348898008484427979425390731194056570529937744140625
end

defp power_of_5(77) do
661744490042422139897126953655970282852649688720703125
end

defp power_of_5(78) do
3308722450212110699485634768279851414263248443603515625
end

defp power_of_5(79) do
16543612251060553497428173841399257071316242218017578125
end

defp power_of_5(80) do
82718061255302767487140869206996285356581211090087890625
end

defp power_of_5(81) do
413590306276513837435704346034981426782906055450439453125
end

defp power_of_5(82) do
2067951531382569187178521730174907133914530277252197265625
end

defp power_of_5(83) do
10339757656912845935892608650874535669572651386260986328125
end

defp power_of_5(84) do
51698788284564229679463043254372678347863256931304931640625
end

defp power_of_5(85) do
258493941422821148397315216271863391739316284656524658203125
end

defp power_of_5(86) do
1292469707114105741986576081359316958696581423282623291015625
end

defp power_of_5(87) do
6462348535570528709932880406796584793482907116413116455078125
end

defp power_of_5(88) do
32311742677852643549664402033982923967414535582065582275390625
end

defp power_of_5(89) do
161558713389263217748322010169914619837072677910327911376953125
end

defp power_of_5(90) do
807793566946316088741610050849573099185363389551639556884765625
end

defp power_of_5(91) do
4038967834731580443708050254247865495926816947758197784423828125
end

defp power_of_5(92) do
20194839173657902218540251271239327479634084738790988922119140625
end

defp power_of_5(93) do
100974195868289511092701256356196637398170423693954944610595703125
end

defp power_of_5(94) do
504870979341447555463506281780983186990852118469774723052978515625
end

defp power_of_5(95) do
2524354896707237777317531408904915934954260592348873615264892578125
end

defp power_of_5(96) do
12621774483536188886587657044524579674771302961744368076324462890625
end

defp power_of_5(97) do
63108872417680944432938285222622898373856514808721840381622314453125
end

defp power_of_5(98) do
315544362088404722164691426113114491869282574043609201908111572265625
end

defp power_of_5(99) do
1577721810442023610823457130565572459346412870218046009540557861328125
end

defp power_of_5(100) do
7888609052210118054117285652827862296732064351090230047702789306640625
end

defp power_of_5(101) do
39443045261050590270586428264139311483660321755451150238513946533203125
end

defp power_of_5(102) do
197215226305252951352932141320696557418301608777255751192569732666015625
end

defp power_of_5(103) do
986076131526264756764660706603482787091508043886278755962848663330078125
end

defp power_of_5(104) do
4930380657631323783823303533017413935457540219431393779814243316650390625
end

@doc """
Returns a pair of integers whose ratio is exactly equal
to the original float and with a positive denominator.

## Examples

    iex> Float.ratio(0.0)
    {0, 1}
    iex> Float.ratio(3.14)
    {7070651414971679, 2251799813685248}
    iex> Float.ratio(-3.14)
    {-7070651414971679, 2251799813685248}
    iex> Float.ratio(1.5)
    {3, 2}
    iex> Float.ratio(-1.5)
    {-3, 2}
    iex> Float.ratio(16.0)
    {16, 1}
    iex> Float.ratio(-16.0)
    {-16, 1}


"""
def ratio(0.0) do
{0, 1}
end

def ratio(float)  when :erlang.is_float(float) do
case(<<float::float()>>) do
  <<sign::integer()-size(1), 0::integer()-size(11), significant::bitstring()-size(52)>> ->
    {num, _, den} = decompose(significant, 0)
    {sign(sign, num), shift_left(den, 1022)}
  <<sign::integer()-size(1), exp::integer()-size(11), significant::bitstring()-size(52)>> ->
    {num, _, den} = decompose(significant, 1)
    num = sign(sign, num)
    case(:erlang.-(exp, 1023)) do
      exp when :erlang.>(exp, 0) ->
        {den, exp} = shift_right(den, exp)
        {shift_left(num, exp), den}
      exp when :erlang.<(exp, 0) ->
        {num, shift_left(den, :erlang.-(exp))}
      0 ->
        {num, den}
    end
end
end

defp decompose(significant, initial) do
decompose(significant, 1, 0, 2, 1, initial)
end

defp decompose(<<1::integer()-size(1), bits::bitstring()>>, count, last_count, power, _last_power, acc) do
decompose(bits, :erlang.+(count, 1), count, :erlang.bsl(power, 1), power, :erlang.+(shift_left(acc, :erlang.-(count, last_count)), 1))
end

defp decompose(<<0::integer()-size(1), bits::bitstring()>>, count, last_count, power, last_power, acc) do
decompose(bits, :erlang.+(count, 1), last_count, :erlang.bsl(power, 1), last_power, acc)
end

defp decompose(<<>>, _count, last_count, _power, last_power, acc) do
{acc, last_count, last_power}
end

defp sign(0, num) do
num
end

defp sign(1, num) do
:erlang.-(num)
end

defp shift_left(num, times) do
:erlang.bsl(num, times)
end

defp shift_right(num, 0) do
{num, 0}
end

defp shift_right(1, times) do
{1, times}
end

defp shift_right(num, times) do
shift_right(:erlang.bsr(num, 1), :erlang.-(times, 1))
end

@doc """
Returns a charlist which corresponds to the text representation
of the given float.

It uses the shortest representation according to algorithm described
in "Printing Floating-Point Numbers Quickly and Accurately" in
Proceedings of the SIGPLAN '96 Conference on Programming Language
Design and Implementation.

## Examples

    iex> Float.to_charlist(7.0)
    '7.0'


"""
def to_charlist(float)  when :erlang.is_float(float) do
:io_lib_format.fwrite_g(float)
end

@doc """
Returns a binary which corresponds to the text representation
of the given float.

It uses the shortest representation according to algorithm described
in "Printing Floating-Point Numbers Quickly and Accurately" in
Proceedings of the SIGPLAN '96 Conference on Programming Language
Design and Implementation.

## Examples

    iex> Float.to_string(7.0)
    "7.0"


"""
def to_string(float)  when :erlang.is_float(float) do
:erlang.iolist_to_binary(:io_lib_format.fwrite_g(float))
end

def to_char_list(float) do
Float.to_charlist(float)
end

def to_char_list(float, options) do
:erlang.float_to_list(float, expand_compact(options))
end

def to_string(float, options) do
:erlang.float_to_binary(float, expand_compact(options))
end

defp invalid_precision_message(precision) do
<<"precision "::binary(), String.Chars.to_string(precision)::binary(), " is out of valid range of "::binary(), Kernel.inspect(%{__struct__: Range, first: 0, last: 15})::binary()>>
end

defp expand_compact([{:compact, false} | t]) do
expand_compact(t)
end

defp expand_compact([{:compact, true} | t]) do
[:compact | expand_compact(t)]
end

defp expand_compact([h | t]) do
[h | expand_compact(t)]
end

defp expand_compact([]) do
[]
end


end

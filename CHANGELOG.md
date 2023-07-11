# Changelog

## 0.5.3 - 2023/07/08

+ The `BeamFile.Normalizer` generates now different AST formats for 
  `BeamFile.elixir_code/2` and `BeamFile.elixir_quoted/2`. 

## 0.5.2 - 2023/07/08

+ Fix `BeamFile.Normalizer`

## 0.5.1 - 2023/06/15

+ Fix comprehensions
+ Add `:%{}` to `@none_unquotes`

## 0.5.0 - 2023/05/05

+ Require Elixir 1.13
+ Add `BeamFile.elixir_quoted/2`
+ `BeamFile.elixir_code/2` uses now `docs: false` as default opts
+ Refactor code to fix a bunch of errors

## 0.4.2 - 2023/04/03

+ Expand `super/1`

## 0.4.1 - 2023/04/01

+ Fix `BeamFile.elixir_code/2`

## 0.4.0 - 2022/09/08

+ Add `mix` task `beam.file`

## 0.3.3 - 2022/06/08

+ Update docs

## 0.3.2 - 2022/03/09

+ Fix return value for `BeamFile.debug_info/1` when no debug info is available

## 0.3.1 - 2022/02/25

+ Fix `BeamFile.read/1`
+ Fix `BeamFile.exists?/1`
+ Add `excoveralls`
+ Add more tests

## 0.3.0 - 2022/02/19

+ Add `BeamFile.exists?`

## 0.2.0 - 2022/02/18

+ Add `!`-functions.
+ `debug_info` now uses `backend.debug_info/4`

## Breaking changes

+ All functions now expect a module, binary or path as a charlist.

## 0.1.0 - 2021/03/28

+ The very first version.

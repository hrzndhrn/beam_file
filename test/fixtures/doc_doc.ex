defmodule DocDoc do
  @doc "doc"
  def a, do: :a

  @doc ~s'doc"'
  def b, do: :b

  @doc ~S"doc #{55}"
  def c, do: :c

  @doc ~S'doc #{55}"'
  def d, do: :d

  @doc """
  doc
  """
  def e, do: :e

  @doc ~s'''
  doc"""
  '''
  def f, do: :f

  @doc ~S"""
  doc #{55}"
  """
  def g, do: :g

  @doc ~S'''
  doc #{55}"""
  '''
  def h, do: :h
end

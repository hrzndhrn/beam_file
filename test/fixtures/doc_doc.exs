defmodule Elixir.DocDoc do
  @doc "doc"
  def a do
    :a
  end

  @doc ~s'doc"'
  def b do
    :b
  end

  @doc ~S"doc #{55}"
  def c do
    :c
  end

  @doc ~S'doc #{55}"'
  def d do
    :d
  end

  @doc """
  doc
  """
  def e do
    :e
  end

  @doc ~s'''
  doc"""
  '''
  def f do
    :f
  end

  @doc ~S"""
  doc #{55}"
  """
  def g do
    :g
  end

  @doc ~S'''
  doc #{55}"""
  '''
  def h do
    :h
  end
end

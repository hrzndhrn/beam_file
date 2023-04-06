defmodule MultiWhen do
  def call(x)
      when x > 0
      when x < 0 do
    x
  end

  def call2(x)
      when x > 0
      when x < 0
      when x < 10
      when x > -10 do
    x
  end
end

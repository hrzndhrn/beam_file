defmodule MultiWhen do
  def call(x)
      when x > 0
      when x < 0 do
    x
  end
end

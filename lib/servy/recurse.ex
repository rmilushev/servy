defmodule Recurse do
  def loopy([head | tail]) do
    IO.puts "Head: #{head}, tail: #{inspect(tail)}"
    loopy(tail)
  end

  def loopy([]), do: IO.puts "Done!!!"
end

Recurse.loopy([1, 2, 3, 4, 5, 6, 7, 8])

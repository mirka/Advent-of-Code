require Day05
require Day07

{:ok, input} = File.read("inputs/09.txt")

defmodule Day09 do
  def solve(program, inputs \\ []) do
    program
    |> Day07.parse_input()
    |> Day05.solve1(inputs)
    |> Map.get(:outputs)
  end
end

# Day09.solve(input, [2])
# |> IO.inspect()

defmodule Day02Test do
  use ExUnit.Case

  test "Part 1" do
    assert Day02.solve1([1, 0, 0, 0, 99])
           |> Map.values() === [2, 0, 0, 0, 99]

    assert Day02.solve1([2, 3, 0, 3, 99])
           |> Map.values() === [2, 3, 0, 6, 99]

    assert Day02.solve1([2, 4, 4, 5, 99, 0])
           |> Map.values() === [2, 4, 4, 5, 99, 9801]

    assert Day02.solve1([1, 1, 1, 4, 99, 5, 6, 0, 99])
           |> Map.values() === [30, 1, 1, 4, 2, 5, 6, 0, 99]
  end
end

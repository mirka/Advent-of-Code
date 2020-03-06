defmodule Day08Test do
  use ExUnit.Case
  import Day08

  test "Part 2" do
    assert chunk_input("0222112222120000", 2 * 2) |> solve2() === ["0", "1", "1", "0"]
  end
end

defmodule Day05Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Day05

  test "Part 1" do
    assert capture_io(fn -> solve1([3, 0, 4, 0, 99], 5) end) === "5\n"

    assert list_to_map([1, 0, 0, 0, 99])
           |> exec_opcode(0)
           |> Map.values() === [2, 0, 0, 0, 99]

    assert list_to_map([2, 3, 0, 3, 99])
           |> exec_opcode(0)
           |> Map.values() === [2, 3, 0, 6, 99]

    assert list_to_map([2, 4, 4, 5, 99, 0])
           |> exec_opcode(0)
           |> Map.values() === [2, 4, 4, 5, 99, 9801]

    assert list_to_map([1, 1, 1, 4, 99, 5, 6, 0, 99])
           |> exec_opcode(0)
           |> Map.values() === [30, 1, 1, 4, 2, 5, 6, 0, 99]

    assert list_to_map([1002, 4, 3, 4, 33])
           |> exec_opcode(0)
           |> Map.values() === [1002, 4, 3, 4, 99]
  end
end

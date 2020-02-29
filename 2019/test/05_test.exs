defmodule Day05Test do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Day05

  def output_for_integer(n) do
    Integer.to_string(n) <> "\n"
  end

  def run_with_input(program, input) do
    fn ->
      list_to_map(program)
      |> exec_opcode(0, input)
    end
  end

  test "Part 1" do
    assert capture_io(fn -> solve1([3, 0, 4, 0, 99], 5) end) === output_for_integer(5)

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

  test "input is equal to 8 (position mode)" do
    program = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]

    assert capture_io(run_with_input(program, 8)) === output_for_integer(1)
    assert capture_io(run_with_input(program, 7)) === output_for_integer(0)
  end

  test "input is less than 8 (position mode)" do
    program = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]

    assert capture_io(run_with_input(program, 7)) === output_for_integer(1)
    assert capture_io(run_with_input(program, 9)) === output_for_integer(0)
  end

  test "input is equal to 8 (immediate mode)" do
    program = [3, 3, 1108, -1, 8, 3, 4, 3, 99]

    assert capture_io(run_with_input(program, 8)) === output_for_integer(1)
    assert capture_io(run_with_input(program, 7)) === output_for_integer(0)
  end

  test "input is less than 8 (immediate mode)" do
    program = [3, 3, 1107, -1, 8, 3, 4, 3, 99]

    assert capture_io(run_with_input(program, 7)) === output_for_integer(1)
    assert capture_io(run_with_input(program, 9)) === output_for_integer(0)
  end

  test "input is equal to 0 (position mode)" do
    program = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]

    assert capture_io(run_with_input(program, 0)) === output_for_integer(0)
    assert capture_io(run_with_input(program, 5)) === output_for_integer(1)
  end

  test "input is equal to 0 (immediate mode)" do
    program = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]

    assert capture_io(run_with_input(program, 0)) === output_for_integer(0)
    assert capture_io(run_with_input(program, 5)) === output_for_integer(1)
  end

  test "larger program" do
    program =
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    assert capture_io(run_with_input(program, 7)) === output_for_integer(999)
    assert capture_io(run_with_input(program, 8)) === output_for_integer(1000)
    assert capture_io(run_with_input(program, 9)) === output_for_integer(1001)
  end
end

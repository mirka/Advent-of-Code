{:ok, input} = File.read("inputs/16.txt")

defmodule Day16 do
  def parse_input(input) do
    String.split(input, "", trim: true)
    |> Enum.map(fn num -> Integer.parse(num) |> elem(0) end)
  end

  def make_pattern_stream(element_index) do
    list =
      for digit <- [0, 1, 0, -1] do
        List.duplicate(digit, element_index + 1)
      end

    Enum.concat(list)
    |> Stream.cycle()
  end

  def get_multiplier_from_cycle(cycle_index) do
    cycle = cycle_index

    case rem(cycle, 4) do
      0 -> 0
      1 -> 1
      2 -> 0
      3 -> -1
    end
  end

  def get_phased_digit_value(digit, digit_index, element_index, offset \\ 1) do
    cycle = div(digit_index + offset, element_index + 1)

    digit * get_multiplier_from_cycle(cycle)
  end

  def calculate_output_digit(input, element_index) do
    {sum, _} =
      Enum.reduce(input, {0, 0}, fn digit, {acc, index} ->
        {acc + get_phased_digit_value(digit, index, element_index), index + 1}
      end)

    rem(sum, 10) |> abs()
  end

  def calculate_phase(input) do
    Enum.reduce(input, {[], 0}, fn _, {acc, index} ->
      result = calculate_output_digit(input, index)
      {acc ++ [result], index + 1}
    end)
    |> elem(0)
  end

  def exec_phases(input, phase_count) do
    Enum.reduce(1..phase_count, input, fn _, signal ->
      calculate_phase(signal)
    end)
  end

  def solve1(input) do
    parse_input(input)
    |> exec_phases(100)
    |> Enum.take(8)
    |> Enum.join()
  end
end

# Day16.solve1(input)
# |> IO.inspect()

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

  def get_last_digit_of_int(int) do
    rem(int, 10) |> abs()
  end

  def calculate_output_digit(input, element_index) do
    {sum, _} =
      Enum.reduce(input, {0, 0}, fn digit, {acc, index} ->
        {acc + get_phased_digit_value(digit, index, element_index), index + 1}
      end)

    get_last_digit_of_int(sum)
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

  def get_significant_digits(digits, offset) do
    digits
    |> List.duplicate(10000)
    |> List.flatten()
    |> Enum.drop(offset)
  end

  def add_all_digits(digits) do
    Enum.reduce(digits, 0, fn n, sum -> n + sum end)
  end

  def calculate_phase_simple(input) do
    initial_result = add_all_digits(input)

    Enum.reduce(input, {[], 0, initial_result}, fn digit, {acc, previous_digit, last_result} ->
      result = last_result - previous_digit
      {acc ++ [get_last_digit_of_int(result)], digit, result}
    end)
    |> elem(0)
  end

  def exec_phases_simple(input, phase_count) do
    Enum.reduce(1..phase_count, input, fn _, signal ->
      calculate_phase_simple(signal)
    end)
  end

  def solve2(input) do
    input_digits = parse_input(input)

    {offset, _} =
      String.slice(input, 0..6)
      |> Integer.parse()

    get_significant_digits(input_digits, offset)
    |> exec_phases_simple(100)
    |> Enum.take(8)
    |> Enum.join()
  end
end

# Day16.solve2(input)
# |> IO.inspect()

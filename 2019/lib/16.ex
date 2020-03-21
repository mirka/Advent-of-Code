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
    |> Stream.drop(1)
  end

  def calculate_output_digit(input, size, element_index) do
    pattern = make_pattern_stream(element_index) |> Enum.take(size)

    {sum, _} =
      Enum.reduce(input, {0, pattern}, fn digit, {acc, [head | tail]} ->
        {acc + digit * head, tail}
      end)

    rem(sum, 10) |> abs()
  end

  def calculate_phase(input, size) do
    Enum.reduce(input, {[], 0}, fn _, {acc, index} ->
      result = calculate_output_digit(input, size, index)
      {acc ++ [result], index + 1}
    end)
    |> elem(0)
  end

  def exec_phases(input, phase_count) do
    size = length(input)

    Enum.reduce(1..phase_count, input, fn _, signal ->
      calculate_phase(signal, size)
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

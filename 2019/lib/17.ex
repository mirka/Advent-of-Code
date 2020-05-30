require Day05
require Day07

{:ok, input} = File.read("inputs/17.txt")

defmodule Day17 do
  def get_char_at(image, x, y) do
    Enum.at(image, y)
    |> Enum.at(x)
  end

  def is_intersection(image, x, y) do
    coords = [
      [x, y],
      [x - 1, y],
      [x + 1, y],
      [x, y - 1],
      [x, y + 1]
    ]

    Enum.all?(coords, fn [x, y] ->
      get_char_at(image, x, y) === ?#
    end)
  end

  def find_intersections(image) do
    height = length(image)
    width = length(Enum.at(image, 0))

    Enum.reduce(0..(height - 1), [], fn y, intersections ->
      Enum.reduce(0..(width - 1), [], fn x, intersections_by_row ->
        case is_intersection(image, x, y) do
          true -> [[x, y] | intersections_by_row]
          false -> intersections_by_row
        end
      end)
      |> Enum.concat(intersections)
    end)
  end

  def get_alignment_param([x, y]) do
    x * y
  end

  def solve1(program, inputs \\ []) do
    program
    |> Day07.parse_input()
    |> Day05.solve1(inputs)
    |> Map.get(:outputs)
    |> Enum.chunk_by(&(&1 === ?\n))
    |> Enum.reject(&(List.first(&1) === ?\n))
    |> find_intersections()
    |> Enum.reduce(0, fn intersection, sum ->
      sum + get_alignment_param(intersection)
    end)
  end
end

# Day17.solve1(input)
# |> IO.inspect()

{:ok, input} = File.read("inputs/03.txt")

defmodule Vector do
  defstruct [:direction, :distance]
end

defmodule Point do
  defstruct [:x, :y]
end

defmodule Line do
  defstruct [:start, :end, :orientation]
end

defmodule Day03 do
  def string_to_vector(string) do
    String.split(string, ",")
    |> Enum.map(fn string -> String.split_at(string, 1) end)
    |> Enum.map(fn {direction, distance} ->
      %Vector{direction: direction, distance: String.to_integer(distance)}
    end)
  end

  def parse_wires_from_string(string) do
    String.split(string)
    |> Enum.map(&string_to_vector/1)
  end

  def get_line(start_point, vector) do
    end_point =
      (fn ->
         case vector.direction do
           "U" -> %Point{x: start_point.x, y: start_point.y + vector.distance}
           "D" -> %Point{x: start_point.x, y: start_point.y - vector.distance}
           "R" -> %Point{x: start_point.x + vector.distance, y: start_point.y}
           "L" -> %Point{x: start_point.x - vector.distance, y: start_point.y}
         end
       end).()

    line = %Line{start: start_point, end: end_point}
    Map.put(line, :orientation, get_orientation(line))
  end

  def get_lines_for_wire(vectors) do
    Enum.reduce(vectors, [], fn vector, lines ->
      if length(lines) === 0 do
        [get_line(%Point{x: 0, y: 0}, vector)]
      else
        last_endpoint = List.last(lines).end
        lines ++ [get_line(last_endpoint, vector)]
      end
    end)
  end

  def get_orientation(line) do
    if line.start.x === line.end.x, do: :vertical, else: :horizontal
  end

  def is_between(number, {first, last}) do
    number > min(first, last) and number < max(first, last)
  end

  def get_intersection(line1, line2) do
    cond do
      line1.orientation === line2.orientation ->
        nil

      line1.orientation === :horizontal ->
        if is_between(line2.start.x, {line1.start.x, line1.end.x}) &&
             is_between(line1.start.y, {line2.start.y, line2.end.y}) do
          %Point{x: line2.start.x, y: line1.start.y}
        end

      line1.orientation === :vertical ->
        if is_between(line2.start.y, {line1.start.y, line1.end.y}) &&
             is_between(line1.start.x, {line2.start.x, line2.end.x}) do
          %Point{x: line1.start.x, y: line2.start.y}
        end
    end
  end

  def get_all_intersections([wire1, wire2]) do
    Enum.map(wire1, fn line1 ->
      Enum.reduce(wire2, [], fn line2, intersections ->
        case get_intersection(line1, line2) do
          nil -> intersections
          point -> intersections ++ [point]
        end
      end)
    end)
    |> List.flatten()
  end

  def find_distance_to_closest_intersection(intersections) do
    Enum.reduce(intersections, :infinity, fn point, closest_distance ->
      distance = abs(point.x) + abs(point.y)
      if distance < closest_distance, do: distance, else: closest_distance
    end)
  end

  def distance_to_point_on_line(line, point) do
    cond do
      line.orientation === :horizontal && point.y === line.start.y &&
          is_between(point.x, {line.start.x, line.end.x}) ->
        abs(point.x - line.start.x)

      line.orientation === :vertical && point.x === line.start.x &&
          is_between(point.y, {line.start.y, line.end.y}) ->
        abs(point.y - line.start.y)

      true ->
        nil
    end
  end

  def get_line_length(%Line{} = line) do
    abs(line.end.x - line.start.x) + abs(line.end.y - line.start.y)
  end

  def find_distance_to_point(lines, %Point{} = point) do
    Enum.reduce_while(lines, 0, fn line, total_distance ->
      case distance_to_point_on_line(line, point) do
        nil -> {:cont, total_distance + get_line_length(line)}
        distance -> {:halt, total_distance + distance}
      end
    end)
  end

  def find_cumulative_distance_to_closest_intersection([wire1, wire2]) do
    Enum.reduce(wire1, [:infinity, wire2], fn head1,
                                              [
                                                closest,
                                                [head2 | tail2]
                                              ] ->
      sum = head1 + head2
      next = if sum < closest, do: sum, else: closest
      [next, tail2]
    end)
    |> List.first()
  end

  def solve1(input) do
    parse_wires_from_string(input)
    |> Enum.map(&get_lines_for_wire/1)
    |> get_all_intersections
    |> find_distance_to_closest_intersection
  end

  def solve2(input) do
    wires =
      parse_wires_from_string(input)
      |> Enum.map(&get_lines_for_wire/1)

    intersections = get_all_intersections(wires)

    Enum.map(wires, fn wire ->
      Enum.map(intersections, fn point -> find_distance_to_point(wire, point) end)
    end)
    |> find_cumulative_distance_to_closest_intersection
  end
end

{:ok, input} = File.read("inputs/10.txt")

defmodule Day10 do
  # Get x coordinates of asteroids in line
  def parse_line(line) do
    String.split(line, "", trim: true)
    |> Enum.reduce({0, []}, fn point, {index, result} ->
      new_result = if point === "#", do: result ++ [index], else: result
      {index + 1, new_result}
    end)
    |> elem(1)
  end

  def convert_coordinates({x, y}, height) do
    {x, height - 1 - y}
  end

  def parse_input(input, should_adjust_coords \\ false) do
    lines = String.split(input, "\n")
    height = length(lines)

    Enum.reduce(lines, {0, []}, fn line, {index, result} ->
      x_coords = parse_line(line)

      coords_for_line =
        Enum.map(x_coords, fn x ->
          if should_adjust_coords, do: convert_coordinates({x, index}, height), else: {x, index}
        end)

      {index + 1, result ++ coords_for_line}
    end)
    |> elem(1)
  end

  def get_linear_equation({x1, y1}, {x2, y2}) do
    case x1 === x2 do
      true ->
        {:vertical, x1}

      false ->
        slope = (y2 - y1) / (x2 - x1)
        y_intercept = y1 - slope * x1
        fn x -> slope * x + y_intercept end
    end
  end

  def is_virtually_equal(a, b) do
    # floating point margin
    error_margin = 0.001
    a < b + error_margin && a > b - error_margin
  end

  def is_collinear({:vertical, x1}, {x2, _}) do
    x1 === x2
  end

  def is_collinear(linear_equation, {x, y}) do
    is_virtually_equal(linear_equation.(x), y)
  end

  # Given asteroids on the same line, is the station sandwiched by at least two of them?
  def is_sandwiched({x1, y1}, asteroids) do
    are_both_true = &(Map.get(&1, :lower) && Map.get(&1, :higher))

    Enum.reduce_while(asteroids, %{lower: false, higher: false}, fn {x2, y2}, result ->
      if are_both_true.(result) do
        {:halt, result}
      else
        # Compare y if vertical line
        is_station_lower = if x1 === x2, do: y1 < y2, else: x1 < x2
        token = if is_station_lower, do: :lower, else: :higher
        {:cont, Map.put(result, token, true)}
      end
    end)
    |> are_both_true.()
  end

  def detectable_asteroid_count(_, nil, count) do
    count
  end

  def detectable_asteroid_count(_, asteroids, count) when length(asteroids) === 0 do
    count
  end

  def detectable_asteroid_count(station, [asteroid | remaining], total_count)
      when station === asteroid do
    detectable_asteroid_count(station, remaining, total_count)
  end

  def detectable_asteroid_count(station, [asteroid | remaining], total_count) do
    linear_equation = get_linear_equation(station, asteroid)

    collinear =
      Enum.group_by(remaining, fn ast ->
        if station === ast do
          :identity
        else
          is_collinear(linear_equation, ast)
        end
      end)

    count = if is_sandwiched(station, Map.get(collinear, true, []) ++ [asteroid]), do: 2, else: 1
    detectable_asteroid_count(station, Map.get(collinear, false), total_count + count)
  end

  def detectable_asteroid_count(station, asteroids) do
    detectable_asteroid_count(station, asteroids, 0)
  end

  def get_best_location(asteroids) do
    {best, count, _} =
      Enum.reduce(asteroids, {nil, 0, asteroids}, fn station,
                                                     {best_station, max_count,
                                                      [_ | other_asteroids]} ->
        count = detectable_asteroid_count(station, other_asteroids)

        if count > max_count do
          {station, count, other_asteroids ++ [station]}
        else
          {best_station, max_count, other_asteroids ++ [station]}
        end
      end)

    {best, count}
  end

  def get_angle_deg({x1, y1}, {x2, y2}) do
    case x1 === x2 do
      true ->
        # vertical line
        if y2 < y1, do: 180.0, else: 0.0

      false ->
        slope = (y2 - y1) / (x2 - x1)

        deg = :math.atan(slope) * (180 / :math.pi())

        cond do
          deg === 0.0 ->
            # horizontal line
            if x2 < x1, do: 270.0, else: 90.0

          x2 > x1 ->
            90.0 - deg

          x2 < x1 ->
            270 - deg

          true ->
            180 + deg
        end
    end
  end

  def index_by_angle(station, asteroids) do
    index_by_angle(station, asteroids, %{})
  end

  def index_by_angle(_, nil, asteroids_by_angle) do
    asteroids_by_angle
  end

  def index_by_angle(station, [asteroid | remaining], asteroids_by_angle) do
    angle_deg = get_angle_deg(station, asteroid)

    same_angle =
      Enum.group_by(remaining, fn ast ->
        if station === ast do
          :identity
        else
          is_virtually_equal(angle_deg, get_angle_deg(station, ast))
        end
      end)

    sorted_asteroids =
      Enum.sort_by(
        Map.get(same_angle, true, []) ++ [asteroid],
        & &1,
        &sort_by_distance_from_station(station, &1, &2)
      )

    updated_map = Map.put(asteroids_by_angle, angle_deg, sorted_asteroids)

    index_by_angle(station, Map.get(same_angle, false), updated_map)
  end

  def sort_by_distance_from_station({station_x, station_y}, {x1, y1}, {x2, y2}) do
    [distance1, distance2] =
      if station_x === x1 do
        [y1 - station_y, y2 - station_y]
      else
        [x1 - station_x, x2 - station_x]
      end

    abs(distance1) <= abs(distance2)
  end

  def map_to_sorted_list(map) do
    Map.keys(map)
    |> Enum.sort()
    |> Enum.map(fn key ->
      Map.get(map, key)
    end)
  end

  def asteroid_vaporized_at(asteroids, asteroid_index, current_index \\ 0)

  def asteroid_vaporized_at([[first_head | _] | _], asteroid_index, current_index)
      when asteroid_index === current_index do
    first_head
  end

  def asteroid_vaporized_at([[_ | first_tail] | tail], asteroid_index, current_index) do
    next_list = tail ++ if length(first_tail) > 0, do: [first_tail], else: []
    asteroid_vaporized_at(next_list, asteroid_index, current_index + 1)
  end

  def solve1(input) do
    input
    |> parse_input()
    |> get_best_location
  end

  def solve2(input, station, height, asteroid_index) do
    asteroids =
      input
      |> parse_input(true)

    index_by_angle(station, asteroids)
    |> map_to_sorted_list
    |> asteroid_vaporized_at(asteroid_index - 1)
    |> convert_coordinates(height)
  end
end

# Day10.solve2(input, Day10.convert_coordinates({23, 29}, 33), 33, 200)
# |> IO.inspect()

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

  def parse_input(input) do
    String.split(input, "\n")
    |> Enum.reduce({0, []}, fn line, {index, result} ->
      x_coords = parse_line(line)

      coords_for_line = Enum.map(x_coords, &{&1, index})

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

  def is_collinear({:vertical, x1}, {x2, _}) do
    x1 === x2
  end

  def is_collinear(linear_equation, {x, y}) do
    # floating point margin
    error_margin = 0.0001
    answer = linear_equation.(x)
    answer < y + error_margin && answer > y - error_margin
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

  def solve1(input) do
    input
    |> parse_input()
    |> get_best_location
  end
end

Day10.solve1(input)
|> IO.inspect()

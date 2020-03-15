require Math

{:ok, input} = File.read("inputs/12.txt")

defmodule Moon do
  defstruct position: %{x: 0, y: 0, z: 0}, velocity: %{x: 0, y: 0, z: 0}
end

defmodule Day12 do
  def parse_input(string) do
    string
    |> String.split("\n")
    |> Enum.map(fn str ->
      captures = Regex.named_captures(~r/<x=(?<x>.+?), y=(?<y>.+?), z=(?<z>.+?)>/, str)

      for {key, value} <- captures,
          into: %{},
          do: {String.to_atom(key), elem(Integer.parse(value), 0)}
    end)
  end

  def to_moons(positions) do
    Enum.reduce(positions, {%{}, 0}, fn moon, {moons, index} ->
      updated_map = Map.put(moons, index, %Moon{position: moon})
      {updated_map, index + 1}
    end)
    |> elem(0)
  end

  def do_step(moons) do
    moons
    |> apply_gravity()
    |> apply_velocity()
  end

  def step_for(moons, count, current \\ 1)

  def step_for(moons, count, current) when current > count do
    moons
  end

  def step_for(moons, count, current) do
    do_step(moons)
    |> step_for(count, current + 1)
  end

  def get_gravity_adjustment_for_point(n, other_n) do
    cond do
      n === other_n -> 0
      n < other_n -> 1
      true -> -1
    end
  end

  def apply_gravity_for_moon(moon, other_moon) do
    adjustments =
      for {key, value} <- moon.position,
          into: %{},
          do: {key, get_gravity_adjustment_for_point(value, other_moon.position[key])}

    updated_velocity =
      for {key, value} <- moon.velocity, into: %{}, do: {key, value + adjustments[key]}

    Map.put(moon, :velocity, updated_velocity)
  end

  def apply_gravity(moons, index \\ 0)

  def apply_gravity(moons, index) when index > 3 do
    moons
  end

  def apply_gravity(moons, index) do
    [_ | tail] = Enum.to_list(index..3)

    Enum.reduce(tail, moons, fn other_i, moons ->
      Map.put(moons, index, apply_gravity_for_moon(moons[index], moons[other_i]))
      |> Map.put(other_i, apply_gravity_for_moon(moons[other_i], moons[index]))
    end)
    |> apply_gravity(index + 1)
  end

  def apply_velocity(%{position: position, velocity: velocity} = moon) do
    updated_position = for {key, value} <- position, into: %{}, do: {key, value + velocity[key]}
    Map.put(moon, :position, updated_position)
  end

  def apply_velocity(moons) do
    for {key, value} <- moons, into: %{}, do: {key, apply_velocity(value)}
  end

  def calculate_coord_energy(coords) do
    Enum.reduce(coords, 0, fn {_, value}, sum ->
      sum + abs(value)
    end)
  end

  def calculate_total_energy(moons) do
    Enum.reduce(moons, 0, fn {_, %{position: position, velocity: velocity}}, total ->
      total + calculate_coord_energy(position) * calculate_coord_energy(velocity)
    end)
  end

  def to_map(points) do
    velocity = [0, 0, 0, 0]

    Enum.reduce(points, {%{}, 0}, fn n, {map, index} ->
      entry = %{position: %{n: n}, velocity: %{n: Enum.at(velocity, index)}}
      {Map.put(map, index, entry), index + 1}
    end)
    |> elem(0)
  end

  def get_next_points(%{} = state) do
    do_step(state)
  end

  def steps_until_repeat_for_point(points) do
    first = to_map(points)

    Stream.iterate(get_next_points(first), &get_next_points/1)
    |> Enum.reduce_while(1, fn current, count ->
      if current === first, do: {:halt, count}, else: {:cont, count + 1}
    end)
  end

  def steps_until_repeat(moons) do
    [x, y, z] =
      Enum.map([:x, :y, :z], fn key ->
        Map.values(moons)
        |> Enum.map(& &1.position[key])
        |> steps_until_repeat_for_point()
      end)

    Math.lcm(x, y)
    |> Math.lcm(z)
  end

  def solve1(input) do
    input
    |> parse_input()
    |> to_moons()
    |> step_for(1000)
    |> calculate_total_energy()
  end

  def solve2(input) do
    input
    |> parse_input()
    |> to_moons()
    |> steps_until_repeat()
  end
end

# Day12.solve2(input)
# |> IO.inspect()

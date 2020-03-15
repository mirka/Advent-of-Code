defmodule Day12Test do
  use ExUnit.Case
  import Day12

  test "Parse input" do
    input = "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>"
    assert parse_input(input) === [%{x: -1, y: 0, z: 2}, %{x: 2, y: -10, z: -7}]
  end

  test "Apply gravity for moon" do
    moon = %Moon{position: %{x: -1, y: 0, z: 2}}
    other_moon = %Moon{position: %{x: 2, y: -10, z: -7}}
    assert apply_gravity_for_moon(moon, other_moon).velocity === %{x: 1, y: -1, z: -1}
  end

  test "Apply velocity" do
    input = "<x=-1, y=0, z=2>"

    moons =
      parse_input(input)
      |> to_moons()
      |> Enum.map(fn {key, moon} ->
        {key, Map.put(moon, :velocity, %{x: 1, y: -2, z: 3})}
      end)

    assert apply_velocity(moons)[0].position === %{x: 0, y: -2, z: 5}
  end

  test "Do step" do
    input = "<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>"

    assert parse_input(input) |> to_moons() |> step_for(1) === %{
             0 => %Moon{position: %{x: 2, y: -1, z: 1}, velocity: %{x: 3, y: -1, z: -1}},
             1 => %Moon{position: %{x: 3, y: -7, z: -4}, velocity: %{x: 1, y: 3, z: 3}},
             2 => %Moon{position: %{x: 1, y: -7, z: 5}, velocity: %{x: -3, y: 1, z: -3}},
             3 => %Moon{position: %{x: 2, y: 2, z: 0}, velocity: %{x: -1, y: -3, z: 1}}
           }
  end

  test "Calculate coordinate energy" do
    assert calculate_coord_energy(%{x: 2, y: 1, z: -3}) === 6
  end

  test "Calculate total energy" do
    input = "<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>"

    assert parse_input(input)
           |> to_moons()
           |> step_for(10)
           |> calculate_total_energy() === 179
  end

  test "Get next points" do
    map = to_map([-1, 2, 4, 3])

    assert get_next_points(map) === %{
             0 => %{position: %{n: 2}, velocity: %{n: 3}},
             1 => %{position: %{n: 3}, velocity: %{n: 1}},
             2 => %{position: %{n: 1}, velocity: %{n: -3}},
             3 => %{position: %{n: 2}, velocity: %{n: -1}}
           }
  end

  test "Steps until repeat for point" do
    assert steps_until_repeat_for_point([-1, 2, 4, 3]) === 18
  end

  test "Steps until repeat" do
    moons =
      "<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>"
      |> parse_input()
      |> to_moons()

    assert steps_until_repeat(moons) === 2772
  end
end

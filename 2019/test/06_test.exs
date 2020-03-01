defmodule Day06Test do
  use ExUnit.Case
  import Day06

  def test_orbit_count(input, start_at) do
    parse_input(input)
    |> build_map
    |> get_orbit_count(start_at)
  end

  test "Part 1" do
    input = "COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L"
    assert test_orbit_count(input, "D") === 3
    assert test_orbit_count(input, "L") === 7
    assert test_orbit_count(input, "COM") === 0
    assert solve1(input) === 42
  end

  test "Part 2" do
    input = "COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN"
    assert solve2(input) === 4
  end
end

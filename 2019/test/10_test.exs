defmodule Day10Test do
  use ExUnit.Case
  import Day10

  def test_asteroids_by_range(range, func) do
    Enum.map(range, func)
  end

  def test_sort_by_distance(station, asteroids) do
    Enum.sort_by(
      asteroids,
      & &1,
      &sort_by_distance_from_station(station, &1, &2)
    )
  end

  test "Parse input" do
    input = ".#\n#."
    assert parse_input(input) === [{1, 0}, {0, 1}]
  end

  test "Get linear equation 1" do
    equation = get_linear_equation({3, 7}, {5, 11})
    assert equation.(3) == 7
  end

  test "Get linear equation 2" do
    equation = get_linear_equation({1, 0}, {0, 1})
    assert equation.(1) == 0
    assert equation.(0) == 1
  end

  test "Is vertical line" do
    {:vertical, x} = get_linear_equation({1, 0}, {1, 1})
    assert x === 1
  end

  test "Is collinear" do
    equation = get_linear_equation({1, 0}, {3, 0})
    assert is_collinear(equation, {1, 0}) === true
    assert is_collinear(equation, {2, 0}) === true
    assert is_collinear(equation, {2, 1}) === false
  end

  test "Detectable asteroid count" do
    input = ".#..#
.....
#####
....#
...##"

    [station | asteroids] = parse_input(input)
    assert detectable_asteroid_count(station, asteroids) === 7
  end

  test "Detectable asteroid counts" do
    input = ".#..#
.....
#####
....#
...##"

    asteroids = parse_input(input)
    assert detectable_asteroid_count({0, 2}, asteroids) === 6
  end

  test "Get best location 1" do
    input = ".#..#
.....
#####
....#
...##"

    result =
      parse_input(input)
      |> get_best_location()

    assert result === {{3, 4}, 8}
  end

  test "Is sandwiched" do
    assert is_sandwiched({3, 6}, [{1, 2}, {4, 7}]) === true
    assert is_sandwiched({1, 2}, [{3, 6}, {4, 7}]) === false
  end

  test "Get best location 2" do
    input = "......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####"

    result =
      parse_input(input)
      |> get_best_location()

    assert result === {{5, 8}, 33}
  end

  test "Get best location 3" do
    input = "#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###."

    result =
      parse_input(input)
      |> get_best_location()

    assert result === {{1, 2}, 35}
  end

  test "Get best location 4" do
    input = ".#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#.."

    result =
      parse_input(input)
      |> get_best_location()

    assert result === {{6, 3}, 41}
  end

  test "Floating point errors" do
    input = ".#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##"

    asteroids = parse_input(input)
    assert detectable_asteroid_count({11, 13}, asteroids) === 210
  end

  test "Don't detect self" do
    assert detectable_asteroid_count({1, 1}, [{1, 1}]) === 0
  end

  test "Get angle" do
    assert get_angle_deg({0, 0}, {0, 1}) === 0.0
    assert get_angle_deg({0, 0}, {1, 1}) === 45.0
    assert get_angle_deg({0, 0}, {1, 0}) === 90.0
    assert get_angle_deg({0, 1}, {1, 0}) === 135.0
    assert get_angle_deg({0, 1}, {0, 0}) === 180.0
    assert get_angle_deg({1, 1}, {0, 0}) === 225.0
    assert get_angle_deg({1, 0}, {0, 0}) === 270.0
    assert get_angle_deg({1, 0}, {0, 1}) === 315.0
  end

  test "Sort by distance from station" do
    assert test_sort_by_distance({0, 1}, [{0, 2}, {0, 3}]) === [{0, 2}, {0, 3}]
    assert test_sort_by_distance({1, 1}, [{2, 2}, {3, 3}]) === [{2, 2}, {3, 3}]
    assert test_sort_by_distance({1, 0}, [{3, 0}, {2, 0}]) === [{2, 0}, {3, 0}]
    assert test_sort_by_distance({1, 1}, [{4, 4}, {2, 2}]) === [{2, 2}, {4, 4}]
    assert test_sort_by_distance({5, 5}, [{5, 4}, {5, 2}]) === [{5, 4}, {5, 2}]
    assert test_sort_by_distance({5, 5}, [{4, 4}, {1, 1}]) === [{4, 4}, {1, 1}]
    assert test_sort_by_distance({5, 5}, [{4, 5}, {1, 5}]) === [{4, 5}, {1, 5}]
    assert test_sort_by_distance({5, 0}, [{4, 1}, {3, 2}]) === [{4, 1}, {3, 2}]
  end

  test "Vaporized order 1" do
    input = ".#....#####...#..
##...##.#####..##
##...#...#.#####.
..#.....#...###..
..#.#.....#....##"

    height = 5
    station = convert_coordinates({8, 3}, height)
    solver = &solve2(input, station, height, &1)

    assert test_asteroids_by_range(1..9, solver) === [
             {8, 1},
             {9, 0},
             {9, 1},
             {10, 0},
             {9, 2},
             {11, 1},
             {12, 1},
             {11, 2},
             {15, 1}
           ]

    assert test_asteroids_by_range(10..18, solver) === [
             {12, 2},
             {13, 2},
             {14, 2},
             {15, 2},
             {12, 3},
             {16, 4},
             {15, 4},
             {10, 4},
             {4, 4}
           ]

    assert test_asteroids_by_range(19..27, solver) === [
             {2, 4},
             {2, 3},
             {0, 2},
             {1, 2},
             {0, 1},
             {1, 1},
             {5, 2},
             {1, 0},
             {5, 1}
           ]

    assert test_asteroids_by_range(28..36, solver) === [
             {6, 1},
             {6, 0},
             {7, 0},
             {8, 0},
             {10, 1},
             {14, 0},
             {16, 1},
             {13, 3},
             {14, 3}
           ]
  end

  test "Vaporized order 2" do
    input = ".#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##"

    height = 20
    station = convert_coordinates({11, 13}, height)

    first_three_asteroids =
      Enum.map(1..3, fn index ->
        solve2(input, station, height, index)
      end)

    assert first_three_asteroids === [{11, 12}, {12, 1}, {12, 2}]
    assert solve2(input, station, height, 20) === {16, 0}
    assert solve2(input, station, height, 50) === {16, 9}
    assert solve2(input, station, height, 100) === {10, 16}
    assert solve2(input, station, height, 199) === {9, 6}
    assert solve2(input, station, height, 200) === {8, 2}
    assert solve2(input, station, height, 299) === {11, 1}
  end
end

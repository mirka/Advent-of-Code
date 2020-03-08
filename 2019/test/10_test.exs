defmodule Day10Test do
  use ExUnit.Case
  import Day10

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

  test "Get best location 5" do
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

    result =
      parse_input(input)
      |> get_best_location()

    assert result === {{11, 13}, 210}
  end

  test "Temp" do
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
end

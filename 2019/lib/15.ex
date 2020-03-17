require Day05
require Day07
require ScreenDraw

{:ok, input} = File.read("inputs/15.txt")

defmodule RepairDroid do
  defstruct map: %{}, position: {0, 0}

  def move(program, direction) do
    {[status], new_program} =
      Day05.solve1(program, [direction])
      |> Map.pop(:outputs)

    droid_state = parse_status(status, direction, Map.get(new_program, :droid, %RepairDroid{}))

    Map.put(new_program, :droid, droid_state)
  end

  def get_position_in_direction(direction, {x, y}) do
    case direction do
      1 -> {x, y + 1}
      2 -> {x, y - 1}
      3 -> {x - 1, y}
      4 -> {x + 1, y}
    end
  end

  def get_reverse_direction(direction) do
    case direction do
      1 -> 2
      2 -> 1
      3 -> 4
      4 -> 3
    end
  end

  def reverse_if_moved(program, direction, target_position) do
    if program.droid.position === target_position do
      move(program, get_reverse_direction(direction))
    else
      program
    end
  end

  def find_open_direction(%RepairDroid{map: map, position: position}, current_direction) do
    Enum.filter(1..4, fn direction ->
      target_position = get_position_in_direction(direction, position)
      direction !== get_reverse_direction(current_direction) && map[target_position] !== "#"
    end)
  end

  def try_adjacent(program) do
    Enum.reduce(1..4, program, fn direction, current_program ->
      %{map: map, position: position} = current_program.droid
      target_position = get_position_in_direction(direction, position)

      if Map.get(map, target_position) !== "#" do
        move(current_program, direction)
        |> reverse_if_moved(direction, target_position)
      else
        current_program
      end
    end)
  end

  def move_and_sweep(program, direction) do
    move(program, direction)
    |> try_adjacent()
  end

  def parse_status(status, direction, %RepairDroid{map: map, position: position} = droid_state) do
    target_position = get_position_in_direction(direction, position)

    case status do
      0 ->
        new_map = Map.put(map, target_position, "#")
        Map.put(droid_state, :map, new_map)

      1 ->
        new_map = Map.put(map, target_position, ".")

        Map.put(droid_state, :map, new_map)
        |> Map.put(:position, target_position)

      2 ->
        new_map = Map.put(map, target_position, "O")

        Map.put(droid_state, :map, new_map)
        |> Map.put(:position, target_position)
    end
  end

  def draw(%{droid: droid_state}) do
    %RepairDroid{map: map, position: position} = droid_state

    map_with_droid = if map[position] === "O", do: map, else: Map.put(map, position, "@")

    ScreenDraw.find_bounds(map_with_droid)
    |> ScreenDraw.render(fn coord -> Map.get(map_with_droid, coord, " ") end)
  end
end

defmodule Day15 do
  def print(program) do
    RepairDroid.draw(program)
    |> Enum.map(&IO.puts/1)
  end

  def venture(program, direction, steps \\ 1) do
    new_program = RepairDroid.move_and_sweep(program, direction)
    %{map: map, position: position} = new_program.droid

    if map[position] === "O" do
      {new_program, steps}
    else
      next_directions = RepairDroid.find_open_direction(new_program.droid, direction)

      Enum.map(next_directions, fn direction ->
        venture(new_program, direction, steps + 1)
      end)
      |> Enum.find(&(&1 !== nil))
    end
  end

  def solve1(program) do
    {new_program, steps} =
      program
      |> Day07.parse_input()
      |> Day05.list_to_map()
      |> Map.put(:droid, %RepairDroid{})
      |> venture(3)

    print(new_program)
    steps
  end
end

# Day15.solve1(input)
# |> IO.inspect()

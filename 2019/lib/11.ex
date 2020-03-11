require Day05
require Day07

{:ok, input} = File.read("inputs/11.txt")

defmodule HullPanels do
  defstruct map: %{}, direction: 0, position: {0, 0}

  def get_color(panels) do
    Map.get(panels.map, panels.position, 0)
  end

  def paint(panels, color) do
    if color < 0 || color > 1 do
      raise "WEIRD COLOR: #{color}"
    end

    new_map = Map.put(panels.map, panels.position, color)
    Map.put(panels, :map, new_map)
  end

  def move_to(panels, direction_manipulator) do
    new_direction = direction_manipulator.(panels.direction)

    Map.put(panels, :direction, new_direction)
    |> Map.update!(:position, fn pos -> PaintingRobot.turn(pos, new_direction) end)
  end
end

defmodule PaintingRobot do
  def make_direction_manipulator(command) do
    fn current_direction ->
      case command do
        0 -> current_direction - 90
        1 -> current_direction + 90
      end
      |> normalize_direction()
    end
  end

  def normalize_direction(direction) do
    cond do
      direction < 0 -> direction + 360
      direction >= 360 -> rem(direction, 360)
      true -> direction
    end
  end

  def turn({x, y}, direction) do
    case normalize_direction(direction) do
      0 -> {x, y + 1}
      90 -> {x + 1, y}
      180 -> {x, y - 1}
      270 -> {x - 1, y}
    end
  end

  def paint_and_turn(panels, color, command) do
    direction_manipulator = make_direction_manipulator(command)

    HullPanels.paint(panels, color)
    |> HullPanels.move_to(direction_manipulator)
  end
end

defmodule Day11 do
  def exec_cycle(program, input, count \\ 0) do
    new_program = Day05.solve1(program, [input])

    [color, command] = new_program.outputs

    new_panels = PaintingRobot.paint_and_turn(program.panels, color, command)

    current_color = HullPanels.get_color(new_panels)

    if Map.get(new_program, :done) do
      new_panels
    else
      Map.put(new_program, :panels, new_panels)
      |> exec_cycle(current_color, count + 1)
    end
  end

  def solve1(input) do
    input
    |> Day07.parse_input()
    |> Day05.list_to_map()
    |> Map.put(:panels, %HullPanels{})
    |> exec_cycle(0)
    |> Map.get(:map)
    |> Map.keys()
    |> length
  end
end

Day11.solve1(input)
|> IO.inspect()

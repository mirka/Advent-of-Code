require Day05
require Day07
require ScreenDraw

{:ok, input} = File.read("inputs/13.txt")

defmodule Joystick do
  def stay(count) when count < 0, do: []
  def stay(count), do: List.duplicate(0, count)
  def left(count), do: List.duplicate(-1, count)
  def right(count), do: List.duplicate(1, count)

  def delta(delta) when delta < 0, do: abs(delta) |> left()
  def delta(delta) when delta > 0, do: abs(delta) |> right()
  def delta(_), do: []
end

defmodule Breakout do
  def play(program, commands) do
    {outputs, new_program} =
      Day05.solve1(program, commands)
      |> Map.pop(:outputs)

    if outputs === nil do
      new_program
    else
      existing_map = Map.get(new_program, :map, %{})
      merged_map = parse_outputs(outputs, existing_map)

      new_program
      |> Map.put(:map, merged_map)
    end
  end

  def generate_pixel_func(map) do
    fn coord ->
      case map[coord] do
        0 -> " "
        1 -> "#"
        2 -> "="
        3 -> "_"
        4 -> "o"
      end
    end
  end

  def parse_outputs(outputs, existing_map \\ %{}) do
    Enum.chunk_every(outputs, 3)
    |> Enum.reduce(existing_map, fn [x, y, tile_id], map ->
      Map.put(map, {x, y}, tile_id)
    end)
  end

  def render_map(%{map: map}) do
    {score, actual_map} = Map.pop(map, {-1, 0})
    bounds = ScreenDraw.find_bounds(actual_map)
    screen = ScreenDraw.render(bounds, generate_pixel_func(actual_map))
    [screen, score]
  end
end

defmodule Day13 do
  @paddle_start_column 22

  def get_block_tile_count(outputs) do
    Enum.chunk_every(outputs, 3)
    |> Enum.reduce(0, fn [_, _, tile_id], total ->
      if tile_id === 2, do: total + 1, else: total
    end)
  end

  def paddle_position(nil), do: @paddle_start_column

  def paddle_position(map) do
    Enum.find(1..42, fn column ->
      map[{column, 22}] === 3
    end)
  end

  def ball_destination(nil), do: nil

  def ball_destination(map) do
    Enum.find(1..42, fn column ->
      map[{column, 21}] === 4
    end)
  end

  def next_ball_target(program, ticks \\ 1) do
    new_program = Breakout.play(program, Joystick.stay(1))

    case ball_destination(new_program.map) do
      nil -> next_ball_target(new_program, ticks + 1)
      column -> {column, ticks}
    end
  end

  def do_next_paddle(program, head_start_joystick \\ :stay) do
    if head_start_joystick !== :stay do
      IO.inspect("Headstart: #{head_start_joystick}")
    end

    {target, ticks} = next_ball_target(program)

    paddle_position =
      Map.get(program, :map)
      |> paddle_position()

    delta = target - paddle_position

    IO.inspect("target: #{target}, paddle: #{paddle_position}")
    IO.inspect("ticks: #{ticks}, delta: #{delta}")
    IO.inspect("===")

    if abs(delta) > ticks + 1 do
      {:error, program, delta}
    else
      new_program =
        Breakout.play(program, Joystick.delta(delta))
        |> Breakout.play(Joystick.stay(ticks - abs(delta)))
        |> Breakout.play(apply(Joystick, head_start_joystick, [1]))

      {:ok, new_program}
    end
  end

  def smart_player(program, rollbacks \\ {nil, nil})

  def smart_player({:ok, program}, {_, next_rollback}) do
    {score, _} = Map.pop(program.map, {-1, 0})

    if score === 14747 do
      program
    else
      next = do_next_paddle(program)
      smart_player(next, {next_rollback, program})
    end
  end

  def smart_player({:error, _, delta}, {rollback, next_rollback}) do
    head_start_joystick = if delta < 0, do: :left, else: :right
    rewind = do_next_paddle(rollback, head_start_joystick)
    smart_player(rewind, {rollback, next_rollback})
  end

  def solve1(program, inputs \\ []) do
    program
    |> Day07.parse_input()
    |> Day05.solve1(inputs)
    |> Map.get(:outputs)
    |> get_block_tile_count
  end

  def solve2(program) do
    free_program =
      program
      |> Day07.parse_input()
      |> List.replace_at(0, 2)
      |> Day05.list_to_map()

    free_program
    |> do_next_paddle()
    |> smart_player()
    |> Breakout.render_map()
  end
end

# Day13.solve2(input)
# |> IO.inspect()

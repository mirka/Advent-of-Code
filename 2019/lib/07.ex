require Day05

{:ok, input} = File.read("inputs/07.txt")

defmodule Day07 do
  def parse_input(input) do
    String.split(input, ",")
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(fn {int, _} -> int end)
  end

  def try_settings(program, settings) do
    Enum.reduce(settings, 0, fn setting, last_result ->
      Day05.solve1(program, [setting, last_result], true)
    end)
  end

  def try_settings_loop_mode(program, settings) do
    initial_programs = Enum.reduce(0..4, %{}, fn index, map -> Map.put(map, index, program) end)
    amplifiers = Stream.cycle(0..4)

    next_state =
      Enum.reduce(0..4, {[0], initial_programs}, fn amplifier, {last_results, programs} ->
        case Day05.solve1(programs[amplifier], [Enum.at(settings, amplifier)] ++ last_results) do
          %{outputs: outputs} = result ->
            new_programs = Map.put(programs, amplifier, result)
            {outputs, new_programs}
        end
      end)

    Enum.reduce_while(amplifiers, next_state, fn amplifier, {last_results, programs} ->
      case Day05.solve1(programs[amplifier], last_results) do
        %{done: true} = result when amplifier === 4 ->
          {:halt, Enum.at(result.outputs, 0)}

        %{outputs: outputs} = result ->
          new_programs = Map.put(programs, amplifier, result)
          {:cont, {outputs, new_programs}}
      end
    end)
  end

  def increment_digit(settings, place, _, _) when place < 0 do
    settings
  end

  def increment_digit(settings, place, min, max) do
    digit = Enum.at(settings, place)

    result =
      cond do
        digit === max ->
          List.replace_at(settings, place, min)
          |> increment_digit(place - 1, min, max)

        true ->
          List.replace_at(settings, place, digit + 1)
      end

    if Enum.uniq(result) |> length === 5 do
      result
    else
      increment_digit(result, 4, min, max)
    end
  end

  def settings_generator1() do
    Stream.unfold(Enum.to_list(0..4), fn
      nil ->
        nil

      [4, 3, 2, 1, 0] = settings ->
        {settings, nil}

      settings ->
        {settings, increment_digit(settings, 4, 0, 4)}
    end)
  end

  def settings_generator2() do
    Stream.unfold(Enum.to_list(5..9), fn
      nil ->
        nil

      [9, 8, 7, 6, 5] = settings ->
        {settings, nil}

      settings ->
        {settings, increment_digit(settings, 4, 5, 9)}
    end)
  end

  def solve(input, mode_func, settings_func) do
    program = parse_input(input)

    settings_func.()
    |> Enum.reduce(0, fn settings, max_signal ->
      signal = mode_func.(program, settings)

      max(signal, max_signal)
    end)
  end

  def solve1(input) do
    solve(input, &try_settings/2, &settings_generator1/0)
  end

  def solve2(input) do
    solve(input, &try_settings_loop_mode/2, &settings_generator2/0)
  end
end

# Day07.solve2(input)
# |> IO.inspect()

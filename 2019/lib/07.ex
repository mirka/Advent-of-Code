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

  def increment_digit(settings, place) when place < 0 do
    settings
  end

  def increment_digit(settings, place) do
    result =
      case Enum.at(settings, place) do
        4 ->
          List.replace_at(settings, place, 0)
          |> increment_digit(place - 1)

        n ->
          List.replace_at(settings, place, n + 1)
      end

    if Enum.uniq(result) |> length === 5 do
      result
    else
      increment_digit(result, 4)
    end
  end

  def settings_generator() do
    Stream.unfold([0, 1, 2, 3, 4], fn
      nil ->
        nil

      [4, 3, 2, 1, 0] = settings ->
        {settings, nil}

      settings ->
        {settings, increment_digit(settings, 4)}
    end)
  end

  def solve1(input) do
    program = parse_input(input)

    settings_generator()
    |> Enum.reduce(0, fn settings, max_signal ->
      signal = try_settings(program, settings)
      max(signal, max_signal)
    end)
  end
end

Day07.solve1(input)
|> IO.inspect()

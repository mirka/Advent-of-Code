defmodule Day04 do
  def to_int_array(number) do
    Integer.to_string(number)
    |> String.split("", trim: true)
    |> Enum.map(fn digit ->
      {int, _} = Integer.parse(digit)
      int
    end)
  end

  def has_increasing_digits([head | tail]) do
    cond do
      length(tail) === 0 -> true
      head <= List.first(tail) -> has_increasing_digits(tail)
      true -> false
    end
  end

  def has_double_digit([head | tail]) do
    cond do
      length(tail) === 0 -> false
      head === List.first(tail) -> true
      true -> has_double_digit(tail)
    end
  end

  def is_valid(number) do
    digits = to_int_array(number)
    has_increasing_digits(digits) && has_double_digit(digits)
  end

  def solve1(first, last) do
    Enum.reduce(first..last, 0, fn string, count ->
      if is_valid(string), do: count + 1, else: count
    end)
  end
end

Day04.solve1(193_651, 649_729)
|> IO.inspect()

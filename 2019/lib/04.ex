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

  def has_exact_double_digit([head | tail]) do
    cond do
      length(tail) === 0 -> false
      head === List.first(tail) -> has_exact_double_digit(tail, %{digit: head, count: 1})
      true -> has_exact_double_digit(tail)
    end
  end

  def has_exact_double_digit([head | tail], previous) when length(tail) === 0 do
    head === previous.digit && previous.count === 1
  end

  def has_exact_double_digit([head | tail], previous) do
    cond do
      head !== previous.digit && previous.count === 2 ->
        true

      head === previous.digit && previous.count === 1 ->
        has_exact_double_digit(tail, %{digit: head, count: previous.count + 1})

      true ->
        has_exact_double_digit(tail, %{digit: head, count: 1})
    end
  end

  def is_valid1(number) do
    digits = to_int_array(number)
    has_increasing_digits(digits) && has_double_digit(digits)
  end

  def is_valid2(number) do
    digits = to_int_array(number)
    has_increasing_digits(digits) && has_exact_double_digit(digits)
  end

  def solve(first, last, validator) do
    Enum.reduce(first..last, 0, fn string, count ->
      if validator.(string), do: count + 1, else: count
    end)
  end
end

Day04.solve(193_651, 649_729, &Day04.is_valid2/1)
|> IO.inspect()

{:ok, input} = File.read("inputs/02.txt")

inputs = String.split(input, ",") |> Enum.map(&String.to_integer/1)

defmodule Day02 do
  def exec_opcode(inputs, i, operation_fn) do
    numbers_to_operate_on =
      Enum.to_list(1..2)
      |> Enum.map(fn n -> i + n end)
      |> Enum.map(fn i -> Map.get(inputs, i) end)
      |> Enum.map(fn i -> Map.get(inputs, i) end)

    value = apply(operation_fn, numbers_to_operate_on)

    target_index = Map.get(inputs, i + 3)
    Map.replace!(inputs, target_index, value)
  end

  def solve1(inputs) do
    as_map =
      inputs
      |> Enum.with_index()
      |> Map.new(fn {num, i} -> {i, num} end)

    0..length(inputs)
    |> Enum.reduce_while(as_map, fn i, acc ->
      cond do
        Integer.mod(i, 4) === 0 ->
          case Map.get(acc, i) do
            1 ->
              {:cont, exec_opcode(acc, i, &+/2)}

            2 ->
              {:cont, exec_opcode(acc, i, &*/2)}

            99 ->
              {:halt, acc}
          end

        true ->
          {:cont, acc}
      end
    end)
  end
end

inputs
|> List.replace_at(1, 12)
|> List.replace_at(2, 2)
|> Day02.solve1()
|> Map.get(0)
|> IO.inspect()

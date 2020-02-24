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

  def initial_replace(inputs, noun, verb) do
    inputs
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
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

  def try_all_replacements(inputs, noun, verb, {last_noun, last_verb, last_result}) do
    cond do
      last_result === 19_690_720 ->
        {:ok, last_noun, last_verb}

      noun >= 100 ->
        {:error, 'Did not find answer.'}

      noun < 100 && verb < 100 ->
        result = get_replacement_result(inputs, noun, verb)
        next_noun = if verb === 99, do: noun + 1, else: noun
        next_verb = if verb === 99, do: 0, else: verb + 1
        try_all_replacements(inputs, next_noun, next_verb, {noun, verb, result})
    end
  end

  def get_replacement_result(inputs, noun, verb) do
    inputs
    |> initial_replace(noun, verb)
    |> solve1
    |> Map.get(0)
  end

  def solve2(inputs) do
    try_all_replacements(inputs, 0, 0, {nil, nil, nil})
    |> (fn result ->
          case result do
            {:error, message} ->
              IO.puts(message)

            {:ok, noun, verb} ->
              IO.puts('Found! noun = #{noun} verb = #{verb}')
              IO.puts('Answer: #{100 * noun + verb}')
          end
        end).()
  end
end

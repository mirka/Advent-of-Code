{:ok, input} = File.read("inputs/05.txt")

inputs = String.split(input, ",") |> Enum.map(&String.to_integer/1)

defmodule Day05 do
  def list_to_map(list) do
    Enum.with_index(list)
    |> Map.new(fn {num, i} -> {i, num} end)
  end

  def exec_opcode(program, pointer) do
    code =
      program[pointer]
      |> Opcode.parse_opcode()

    case code do
      {1, modes} ->
        Opcode.arithmetic(program, pointer, modes, &+/2)

      {2, modes} ->
        Opcode.arithmetic(program, pointer, modes, &*/2)

      {3, [mode]} ->
        if length(program.inputs) > 0 do
          [input | tail] = program.inputs

          Map.put(program, :inputs, tail)
          |> Opcode.input(pointer, input, mode)
        else
          Map.put(program, :resume_from, pointer)
        end

      {4, [mode]} ->
        Opcode.output(program, pointer, mode)

      {5, modes} ->
        Opcode.jump(program, pointer, modes, fn n -> n !== 0 end)

      {6, modes} ->
        Opcode.jump(program, pointer, modes, fn n -> n === 0 end)

      {7, modes} ->
        Opcode.write_if(program, pointer, modes, fn n, m -> n < m end)

      {8, modes} ->
        Opcode.write_if(program, pointer, modes, fn n, m -> n === m end)

      {9, [mode]} ->
        Opcode.adjust_relative_base(program, pointer, mode)

      {99, _} ->
        Map.put(program, :done, true)
    end
  end

  def solve1(program, inputs, return_immediately \\ false) do
    normalized_program = if is_list(program), do: list_to_map(program), else: program
    start_from_pointer = Map.get(normalized_program, :resume_from, 0)

    normalized_program
    |> Map.put(:return, return_immediately)
    |> Map.put(:inputs, inputs)
    |> Map.delete(:outputs)
    |> Map.delete(:resume_from)
    |> exec_opcode(start_from_pointer)
  end
end

defmodule Opcode do
  def parse_opcode(opcode) when opcode > 99 do
    position_codes =
      div(opcode, 100)
      |> Integer.to_string()
      |> String.split("", trim: true)
      |> Enum.map(fn digit -> Integer.parse(digit) |> elem(0) end)
      |> Enum.reverse()
      |> Enum.map(fn
        0 -> :position
        1 -> :immediate
        2 -> :relative
      end)

    {rem(opcode, 100), position_codes}
  end

  def parse_opcode(opcode) do
    {opcode, [:position]}
  end

  def get(program, index) do
    Map.get(program, index, 0)
  end

  def get_param(_, index, :immediate) do
    index
  end

  def get_param(program, index, :relative) do
    Map.get(program, :relative_base, 0) + get(program, index)
  end

  # Get by position
  def get_param(program, index, _) do
    get(program, index)
  end

  def arithmetic(program, pointer, modes, func) do
    param1_address = get_param(program, pointer + 1, Enum.at(modes, 0))
    param2_address = get_param(program, pointer + 2, Enum.at(modes, 1))
    answer_address = get_param(program, pointer + 3, Enum.at(modes, 2))

    answer = func.(get(program, param1_address), get(program, param2_address))

    Map.put(program, answer_address, answer)
    |> Day05.exec_opcode(pointer + 4)
  end

  def jump(program, pointer, modes, test_func) do
    param1_address = get_param(program, pointer + 1, Enum.at(modes, 0))
    new_pointer_address = get_param(program, pointer + 2, Enum.at(modes, 1))

    if test_func.(get(program, param1_address)) do
      Day05.exec_opcode(program, get(program, new_pointer_address))
    else
      Day05.exec_opcode(program, pointer + 3)
    end
  end

  def adjust_relative_base(program, pointer, mode) do
    address = get_param(program, pointer + 1, mode)
    amount = get(program, address)

    Map.update(program, :relative_base, amount, &(&1 + amount))
    |> Day05.exec_opcode(pointer + 2)
  end

  def write_if(program, pointer, modes, test_func) do
    param1_address = get_param(program, pointer + 1, Enum.at(modes, 0))
    param2_address = get_param(program, pointer + 2, Enum.at(modes, 1))
    answer_address = get_param(program, pointer + 3, Enum.at(modes, 2))

    value_to_store =
      if test_func.(get(program, param1_address), get(program, param2_address)), do: 1, else: 0

    Map.put(program, answer_address, value_to_store)
    |> Day05.exec_opcode(pointer + 4)
  end

  def input(program, pointer, value, mode) do
    address = get_param(program, pointer + 1, mode)

    Map.put(program, address, value)
    |> Day05.exec_opcode(pointer + 2)
  end

  def output(program, pointer, mode) do
    address = get_param(program, pointer + 1, mode)
    result = get(program, address)

    case Map.get(program, :return) do
      true ->
        result

      _ ->
        Map.update(program, :outputs, [result], fn outputs -> outputs ++ [result] end)
        |> Day05.exec_opcode(pointer + 2)
    end
  end
end

# Day05.solve1(inputs, [5])

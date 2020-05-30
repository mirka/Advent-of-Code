defmodule Day16Test do
  use ExUnit.Case
  import Day16

  test "Pattern stream" do
    assert make_pattern_stream(0) |> Enum.take(6) === [0, 1, 0, -1, 0, 1]
    assert make_pattern_stream(1) |> Enum.take(6) === [0, 0, 1, 1, 0, 0]
  end

  test "Calculate output digit" do
    input = [1, 2, 3, 4, 5, 6, 7, 8]
    assert calculate_output_digit(input, 0) === 4
    assert calculate_output_digit(input, 1) === 8
  end

  test "Calculate phase" do
    input = [1, 2, 3, 4, 5, 6, 7, 8]
    assert calculate_phase(input) === [4, 8, 2, 2, 6, 1, 5, 8]
  end

  test "Execute phases" do
    input = [1, 2, 3, 4, 5, 6, 7, 8]

    assert exec_phases(input, 4) === [0, 1, 0, 2, 9, 4, 9, 8]
  end

  test "Phases for larger inputs" do
    assert solve1("80871224585914546619083218645595") === "24176176"
    assert solve1("19617804207202209144916044189917") === "73745418"
    assert solve1("69317163492948606335995924319873") === "52432133"
  end

  test "Get phased digit value" do
    assert get_phased_digit_value(9, 0, 0) === 9
    assert get_phased_digit_value(9, 2, 1) === 9
    assert get_phased_digit_value(9, 3, 1) === 0
    assert get_phased_digit_value(9, 2, 2) === 9
    assert get_phased_digit_value(9, 4, 2) === 9
    assert get_phased_digit_value(9, 5, 2) === 0
  end

  test "Calculate phase (Part 2)" do
    assert calculate_phase_simple(%{1 => 6, 2 => 7, 3 => 8}, 3) === %{1 => 1, 2 => 5, 3 => 8}
    assert calculate_phase_simple(%{1 => 1, 2 => 5, 3 => 8}, 3) === %{1 => 4, 2 => 3, 3 => 8}
  end

  test "Execute phases (Part 2)" do
    assert exec_phases_simple([6, 7, 8], 4) === %{1 => 4, 2 => 9, 3 => 8}
  end
end

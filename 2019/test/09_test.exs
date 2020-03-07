defmodule Day09Test do
  use ExUnit.Case
  import Day09

  test "Quine" do
    string = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
    result = solve(string)
    assert Enum.join(result, ",") === string
  end

  test "16 digit output" do
    [result] = solve("1102,34915192,34915192,7,4,7,99,0")
    assert Integer.to_string(result) |> String.length() === 16
  end

  test "Large number in middle" do
    assert solve("104,1125899906842624,99") === [1_125_899_906_842_624]
  end
end

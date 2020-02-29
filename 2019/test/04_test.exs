defmodule Day04Test do
  use ExUnit.Case

  test "Part 1" do
    assert Day04.is_valid1(111_111) === true
    assert Day04.is_valid1(223_450) === false
    assert Day04.is_valid1(123_789) === false
  end

  test "Part 2" do
    assert Day04.is_valid2(112_233) === true
    assert Day04.is_valid2(123_444) === false
    assert Day04.is_valid2(111_122) === true
  end
end

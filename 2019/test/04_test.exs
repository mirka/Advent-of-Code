defmodule Day04Test do
  use ExUnit.Case

  test "Part 1" do
    assert Day04.is_valid(111_111) === true
    assert Day04.is_valid(223_450) === false
    assert Day04.is_valid(123_789) === false
  end
end

defmodule Day01Test do
  use ExUnit.Case

  test "Part 1" do
    assert Day01.solve1([12]) == 2
    assert Day01.solve1([14]) == 2
    assert Day01.solve1([1969]) == 654
    assert Day01.solve1([100_756]) == 33583
  end

  test "Part 2" do
    assert Day01.solve2([14]) == 2
    assert Day01.solve2([1969]) == 966
    assert Day01.solve2([100_756]) == 50346
  end
end

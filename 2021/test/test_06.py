from src.day06 import solve1, solve2

values = "3,4,3,1,2".split(',')


def test_solve1():
  assert solve1(values) == 5934


def test_solve2():
  assert solve2(values) == 26984457539

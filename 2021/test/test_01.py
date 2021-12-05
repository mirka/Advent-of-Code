from src.day01 import solve1, solve2

values = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]


def test_solve1():
  assert solve1(values) == 7


def test_solve2():
  assert solve2(values) == 5

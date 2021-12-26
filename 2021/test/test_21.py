from src.day21 import solve1, solve2

values = [4, 8]


def test_solve1():
  assert solve1(values) == 739785


def test_solve2():
  assert solve2(values) == 444356092776315

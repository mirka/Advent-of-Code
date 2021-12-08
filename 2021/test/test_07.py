from src.day07 import solve1, solve2

values = "16,1,2,0,4,2,7,1,2,14".split(',')
values = list(map(int, values))


def test_solve1():
  assert solve1(values) == 37


def test_solve2():
  assert solve2(values) == 168

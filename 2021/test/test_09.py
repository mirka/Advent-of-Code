from src.day09 import solve1, solve2

values = """
2199943210
3987894921
9856789892
8767896789
9899965678
""".strip().split(
    '\n')


def test_solve1():
  assert solve1(values) == 15


def test_solve2():
  assert solve2(values) == 1134

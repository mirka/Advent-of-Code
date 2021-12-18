from src.day17 import solve1, solve2

values = """
target area: x=20..30, y=-10..-5
""".strip()


def test_solve1():
  assert solve1(values) == 45


def test_solve2():
  assert solve2(values) == 112

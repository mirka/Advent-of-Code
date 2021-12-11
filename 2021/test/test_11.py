from src.day11 import solve1, solve2

values = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
""".strip().split(
    '\n')


def test_solve1():
  assert solve1(values) == 1656


def test_solve2():
  assert solve2(values) == 195

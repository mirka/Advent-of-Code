from src.day15 import solve1, solve2

values = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
""".strip().split(
    '\n')


def test_solve1():
  assert solve1(values) == 40


def test_solve2():
  assert solve2(values) == 315

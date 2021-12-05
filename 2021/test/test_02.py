from src.day02 import solve1, solve2

values = ['forward 5',
          'down 5',
          'forward 8',
          'up 3',
          'down 8',
          'forward 2']


def test_solve1():
  assert solve1(values) == 150


def test_solve2():
  assert solve2(values) == 900

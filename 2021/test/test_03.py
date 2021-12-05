from src.day03 import solve1, solve2

values = [
    '00100',
    '11110',
    '10110',
    '10111',
    '10101',
    '01111',
    '00111',
    '11100',
    '10000',
    '11001',
    '00010',
    '01010',
]


def test_solve1():
  assert solve1(values) == 198


def test_solve2():
  assert solve2(values) == 230

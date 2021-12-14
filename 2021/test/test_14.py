from src.day14 import solve1, solve2

values = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
""".strip().split(
    '\n\n')


def test_solve1():
  assert solve1(values) == 1588


def test_solve2():
  assert solve2(values) == 2188189693529

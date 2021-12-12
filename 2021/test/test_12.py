from src.day12 import solve1, solve2

values1 = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
""".strip().split(
    '\n')

values2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
""".strip().split(
    '\n')

values3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
""".strip().split(
    '\n')


def test_solve1():
  assert list(map(solve1, [values1, values2, values3])) == [10, 19, 226]


def test_solve2():
  assert list(map(solve2, [values1, values2, values3])) == [36, 103, 3509]

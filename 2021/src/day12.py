import functools


with open("input/day12.txt", "r") as file:
  values = file.read().strip().split("\n")


def parse(values):
  g = {}
  for e in values:
    a, b = e.split('-')
    g.setdefault(a, []).append(b)
    g.setdefault(b, []).append(a)
  return g


def paths(node, g, v, flag=True):
  if node == 'end':
    return 1
  if node in v and (flag or node == 'start'):
    return 0

  if node.islower():
    if node in v and node != 'start':
      flag = True
    v[node] = True

  return functools.reduce(lambda s, n: s + paths(n, g, v.copy(), flag), g[node], 0)


def solve1(values):
  return paths('start', parse(values), {})


def solve2(values):
  return paths('start', parse(values), {}, False)


# print(solve2(values))

import re

with open("input/day22.txt", "r") as file:
  values = file.read().strip().splitlines()


def parse(values):
  res = []
  for l in values:
    m = re.match(
        r'(.+)\sx=(-?\d+)\.\.(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)', l)

    g = m.groups()
    res.append((1 if g[0] == 'on' else -1, (int(g[1]), int(g[2])),
               (int(g[3]), int(g[4])), (int(g[5]), int(g[6]))))
  return res


def intersects(a, b):
  for i in range(3):
    if a[i][1] < b[i][0] or a[i][0] > b[i][1]:
      return False
  return True


def intersection(a, b):
  if not intersects(a, b) and not intersects(b, a):
    return None
  x, y, z = [sorted(a[i] + b[i]) for i in range(3)]
  return ((x[1], x[2]), (y[1], y[2]), (z[1], z[2]))


def count_cubes(x, y, z):
  return (x[1] - x[0] + 1)*(y[1] - y[0] + 1)*(z[1] - z[0] + 1)


def solve(p):
  cubes = []

  for on, x, y, z in p:
    more = []
    for c, sign in cubes:
      inter = intersection(c, (x, y, z))
      if not inter:
        continue
      more.append((inter, sign * -1))
    cubes += more
    if on == 1:
      cubes.append(((x, y, z), 1))

  return sum([count_cubes(*c) * sign for c, sign in cubes])


def solve1(values):
  p = parse(values)
  p = [l for l in p if -50 <= l[1][0] <= 50]

  return solve(p)


def solve2(values):
  p = parse(values)

  return solve(p)


# print(solve2(values))

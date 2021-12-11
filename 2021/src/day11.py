import functools

with open("input/day11.txt", "r") as file:
  values = file.read().strip().split("\n")


def parse(values):
  return list(list(int(c) for c in l) for l in values)


def flashes(li, ci, m, itr):
  if not 0 <= li < len(m):
    return 0
  if not 0 <= ci < len(m[0]):
    return 0
  if m[li][ci] == itr * -1:
    return 0

  m[li][ci] = max(0, m[li][ci])
  m[li][ci] += 1

  if m[li][ci] < 10:
    return 0

  m[li][ci] = itr * -1

  return functools.reduce(lambda s, c: s + flashes(c[0], c[1], m, itr),
                          [
      [li-1, ci-1], [li-1, ci], [li-1, ci+1],
      [li, ci-1], [li, ci+1],
      [li+1, ci-1], [li+1, ci], [li+1, ci+1]
  ],
      1)


def solve1(values):
  m = parse(values)
  sum = 0

  for itr in range(100):
    for li, l in enumerate(m):
      for ci in range(len(l)):
        sum += flashes(li, ci, m, itr + 1)

  return sum


def solve2(values):
  m = parse(values)

  for itr in range(2000):
    sum = 0
    for li, l in enumerate(m):
      for ci in range(len(l)):
        sum += flashes(li, ci, m, itr + 1)
    if sum == 100:
      return itr + 1


# print(solve2(values))

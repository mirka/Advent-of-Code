import functools

with open("input/day09.txt", "r") as file:
  values = file.read().strip().split("\n")


def parse(values):
  return list(list(int(c) for c in l) for l in values)


def solve1(values):
  m = parse(values)
  return functools.reduce(lambda s, c: s + m[c[0]][c[1]] + 1, get_nadirs(m), 0)


def get_nadirs(m):
  res = []
  for li, l in enumerate(m):
    for ci, c in enumerate(l):
      if ci > 0 and l[ci-1] <= c:
        continue
      if ci < len(l)-1 and l[ci+1] <= c:
        continue
      if li > 0 and m[li-1][ci] <= c:
        continue
      if li < len(m)-1 and m[li+1][ci] <= c:
        continue
      res.append([li, ci])
  return res


def basin(li, ci, m):
  size = 0
  c = m[li][ci]

  if c == 9:
    return size

  if ci > 0 and m[li][ci-1] > c:
    size += basin(li, ci-1, m)
  if ci < len(m[li])-1 and m[li][ci+1] > c:
    size += basin(li, ci+1, m)
  if li > 0 and m[li-1][ci] > c:
    size += basin(li-1, ci, m)
  if li < len(m)-1 and m[li+1][ci] > c:
    size += basin(li+1, ci, m)

  m[li][ci] = 9
  return size + 1


def solve2(values):
  m = parse(values)
  sizes = sorted(
      map(lambda c: basin(c[0], c[1], m), get_nadirs(m)), reverse=True)

  return sizes[0] * sizes[1] * sizes[2]


# print(solve2(values))

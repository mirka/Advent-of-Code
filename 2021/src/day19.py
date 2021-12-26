import re

with open("input/day19.txt", "r") as file:
  values = file.read().strip()


def parse(values):
  m = re.split(r'--- scanner \d+ ---', values)[1:]
  return [[eval(f'({c})') for c in bs.strip().splitlines()] for bs in m]


def distances(s):
  res = []
  for b1 in s:
    res.append(
        {tuple(sorted((abs(b2[0] - b1[0]), abs(b2[1] - b1[1]), abs(b2[2] - b1[2])))) for b2 in s})
  return res


def find_match(s1, s2):
  for i1, b1 in enumerate(s1):
    for i2, b2 in enumerate(s2):
      if len(b1 & b2) >= 12:
        return (i1, i2)


def raw_distances(b, s, i):
  return {orientations((b2[0] - b[0], b2[1] - b[1], b2[2] - b[2]), i) for b2 in s}


def orientations(c, i):
  x, y, z = c
  p = [
      (x, y, z),
      (x, y, -z),
      (x, -y, z),
      (x, -y, -z),
      (-x, y, z),
      (-x, y, -z),
      (-x, -y, z),
      (-x, -y, -z),
      (x, z, y),
      (x, z, -y),
      (x, -z, y),
      (x, -z, -y),
      (-x, z, y),
      (-x, z, -y),
      (-x, -z, y),
      (-x, -z, -y),
      (y, x, z),
      (y, x, -z),
      (y, -x, z),
      (y, -x, -z),
      (-y, x, z),
      (-y, x, -z),
      (-y, -x, z),
      (-y, -x, -z),
      (y, z, x),
      (y, z, -x),
      (y, -z, x),
      (y, -z, -x),
      (-y, z, x),
      (-y, z, -x),
      (-y, -z, x),
      (-y, -z, -x),
      (z, x, y),
      (z, x, -y),
      (z, -x, y),
      (z, -x, -y),
      (-z, x, y),
      (-z, x, -y),
      (-z, -x, y),
      (-z, -x, -y),
      (z, y, x),
      (z, y, -x),
      (z, -y, x),
      (z, -y, -x),
      (-z, y, x),
      (-z, y, -x),
      (-z, -y, x),
      (-z, -y, -x),
  ]
  return p[i]


def find_rotation(b1, b2, scanners):
  d1 = raw_distances(scanners[b1[0]][b1[1]], scanners[b1[0]], 0)
  for rot in range(48):
    d2 = raw_distances(scanners[b2[0]][b2[1]], scanners[b2[0]], rot)
    if len(d1 & d2) >= 12:
      return rot


def find_translation(b1, b2, rot):
  b2 = orientations(b2, rot)
  return (b2[0] - b1[0], b2[1] - b1[1], b2[2] - b1[2])


def solve_core(scanners, rt=[]):
  d = list(map(distances, scanners))
  for i1, s1 in enumerate(d):
    for i2 in range(i1+1, len(d)):
      m = find_match(s1, d[i2])
      if m:
        rot = find_rotation((i1, m[0]), (i2, m[1]), scanners)
        tra = find_translation(scanners[i1][m[0]], scanners[i2][m[1]], rot)
        new_s = [tuple(cp - tra[i]
                       for i, cp in enumerate(orientations(c, rot))) for c in scanners[i2]]
        merged = list(set(scanners[i1] + new_s))
        del scanners[i2]
        del scanners[i1]
        rt.append((rot, tra))
        return ([merged, *scanners], rt)


def find_scanners(rt):
  res = [(0, 0, 0)]
  for rot, tra in rt:
    c = orientations((0, 0, 0), rot)
    c = tuple(p - tra[i] for i, p in enumerate(c))
    res.append(c)
  return res


def find_longest_manhattan(s):
  res = 0
  for s1 in s:
    for s2 in s:
      res = max(res, sum(abs(s1[i] - s2[i]) for i in range(3)))
  return res


def solve1(values):
  scanners = parse(values)
  while len(scanners) > 1:
    scanners, _ = solve_core(scanners)
  return len(scanners[0])


def solve2(values):
  scanners = parse(values)
  while len(scanners) > 1:
    scanners, rt = solve_core(scanners)
  return find_longest_manhattan(find_scanners(rt))


# print(solve2(values))

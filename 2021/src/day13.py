
with open("input/day13.txt", "r") as file:
  values = file.read().strip().split("\n\n")


def parse(values):
  dots, folds = values
  res = {"dots": set(), "folds": []}
  for l in dots.split("\n"):
    res["dots"].add(tuple(map(int, l.split(','))))
  for l in folds.split("\n"):
    _, s = l.split('fold along ')
    c, n = s.split('=')
    res["folds"].append([c, int(n)])
  return res


def fold(dots, fold):
  fc, fn = fold
  res = set()
  for x, y in dots:
    if fc == 'x':
      if x > fn:
        res.add((fn - (x - fn), y))
      else:
        res.add((x, y))
    else:
      if y > fn:
        res.add((x, fn - (y - fn)))
      else:
        res.add((x, y))
  return res


def solve1(values):
  p = parse(values)
  d = fold(p["dots"], p["folds"][0])
  return len(d)


def solve2(values):
  p = parse(values)
  d = p["dots"]
  for f in p["folds"]:
    d = fold(d, f)

  res = []
  for _ in range(50):
    res.append(['.'] * 50)
  for x, y in d:
    res[y][x] = '#'
  return res


# print(solve2(values))

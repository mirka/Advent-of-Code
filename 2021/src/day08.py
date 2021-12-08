with open("input/day08.txt", "r") as file:
  values = file.read().strip().split("\n")


def parse(lines):
  res = []
  for l in lines:
    pattern, digits = l.split('|')
    res.append({"p": pattern.split(), "d": digits.split()})
  return res


def solve1(values):
  vals = parse(values)
  count = 0

  for v in vals:
    for d in v["d"]:
      if len(d) in [2, 3, 4, 7]:
        count += 1

  return count


def to_bits(str):
  res = 0
  for c in str:
    res += (1 << (ord(c) - ord('a')))
  return res


def solve2(values):
  lines = parse(values)
  sum = 0

  for l in lines:
    dm = {}
    five = []
    six = []

    for p in l["p"]:
      ls = [2, 3, 4, 7]
      if len(p) in ls:
        i = [1, 7, 4, 8][ls.index(len(p))]
        dm[i] = to_bits(p)
      elif len(p) == 5:
        five.append(to_bits(p))
      elif len(p) == 6:
        six.append(to_bits(p))

    for s in six:
      if (s & dm[4]) == dm[4]:
        dm[9] = s
        six.remove(s)

    for f in five:
      if bin(f | dm[9]).count('1') == 7:
        dm[2] = f
        five.remove(f)

    for f in five:
      if bin(f | dm[2]).count('1') == 7:
        dm[5] = f
        five.remove(f)
        dm[3] = five[0]

    for s in six:
      if (s & dm[5]) == dm[5]:
        dm[6] = s
        six.remove(s)
        dm[0] = six[0]

    bm = {}
    for k, v in dm.items():
      bm[v] = k

    res = 0
    mult = 1000
    for d in l['d']:
      res += (bm[to_bits(d)]) * mult
      mult /= 10
    sum += res

  return int(sum)


# print(solve2(values))

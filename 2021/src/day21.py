import collections
import itertools

values = [7, 9]


def roll(d):
  n = 1
  while True:
    v = n % d
    yield d if v == 0 else v
    n += 1


class Roll:
  def __init__(self, d):
    self.n = 0
    self.d = d

  def __next__(self):
    self.n += 1
    v = self.n % self.d
    return self.d if v == 0 else v


def play(d):
  while True:
    yield next(d) + next(d) + next(d)


def move(pos, steps):
  v = (pos + steps) % 10
  return 10 if v == 0 else v


def solve1(values):
  a = [values[0], 0]  # pos, score
  b = [values[1], 0]
  r = Roll(100)
  d = play(r)

  while max(a[1], b[1]) < 1000:
    for player in [a, b]:
      steps = next(d)
      player[0] = move(player[0], steps)
      player[1] += player[0]
      if player[1] >= 1000:
        return min([a[1], b[1]]) * r.n

  return values


rolls = collections.Counter(
    [sum(t) for t in itertools.product([1, 2, 3], repeat=3)])


def possibilities(ps):
  res = {}
  for p, freq in ps.items():
    for steps, sf in rolls.items():
      pos = move(p[0], steps)
      score = p[1] + pos
      res[(pos, score)] = sf * freq
  return res


winsa = 0
winsb = 0


def play_rec(ako, bko, freq):
  global winsa, winsb

  a = possibilities({ako: freq})
  for ak, av in a.items():
    if ak[1] >= 21:
      winsa += av
    else:
      b = possibilities({bko: av})
      for bk, bv in b.items():
        if bk[1] >= 21:
          winsb += bv
        else:
          play_rec(ak, bk, bv)


dp = {}


def play_rec_fast(ap, bp, asc, bsc):
  if (ap, bp, asc, bsc) in dp:
    return dp[(ap, bp, asc, bsc)]

  if asc >= 21:
    return [1, 0]
  if bsc >= 21:
    return [0, 1]

  res = [0, 0]

  for i in range(1, 4):
    for j in range(1, 4):
      for k in range(1, 4):
        newp = move(ap, i+j+k)
        a, b = play_rec_fast(bp, newp, bsc, asc + newp)
        res[0] += b
        res[1] += a

  dp[(ap, bp, asc, bsc)] = res
  return res


def solve2(values):
  winsa, winsb = play_rec_fast(values[0], values[1], 0, 0)
  return max(winsa, winsb)


# print(solve2(values))

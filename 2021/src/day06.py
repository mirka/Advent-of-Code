with open("input/day06.txt", "r") as file:
  values = file.read().split(",")


def parse(values):
  return list(map(int, values))


def solve(values, days):
  sum = len(values)
  m = {}

  for n in parse(values):
    if not m.get(n):
      m[n] = spawn(days, n)

    sum += m[n]

  return sum


def solve1(values):
  return solve(values, 80)


def solve2(values):
  return solve(values, 256)


dp = {}


def spawn(day, timer):
  d = day - timer
  sum = 0

  while d > 0:
    sum += 1
    next_d = d - 1

    if not dp.get(next_d):
      dp[next_d] = spawn(next_d, 8)

    sum += dp[next_d]
    d -= 7

  return sum


# print(solve2(values))

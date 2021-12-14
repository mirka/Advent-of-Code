with open("input/day14.txt", "r") as file:
  values = file.read().strip().split("\n\n")


def parse(values):
  str, rules = values
  r = {}
  for l in rules.split('\n'):
    k, v = l.split(' -> ')
    r[k] = v
  return [str, r]


dp = {}


def count(a, b, r, times, ct):
  if times == 0:
    return ct
  next = r[a + b]
  ct.setdefault(next, 0)
  ct[next] += 1

  dp_key = a+next+b+str(times-1)

  if dp_key in dp:
    for k in dp[dp_key]:
      ct[k] += dp[dp_key][k]
    return ct

  s1 = ct.copy()
  ct = count(a, next, r, times-1, ct)
  ct = count(next, b, r, times-1, ct)
  diff = {}
  for k in ct:
    s1.setdefault(k, 0)
    diff[k] = ct[k] - s1[k]
  dp[dp_key] = diff
  return ct


def core_solve(values, step_count):
  str, rules = parse(values)
  ct = {}
  for c in str:
    ct.setdefault(c, 0)
    ct[c] += 1
  times = step_count
  for i in range(len(str) - 1):
    count(str[i], str[i+1], rules, times, ct)
  v = ct.values()

  return max(v) - min(v)


def solve1(values):
  return core_solve(values, 10)


def solve2(values):
  return core_solve(values, 40)

# print(solve2(values))

import heapq

with open("input/day15.txt", "r") as file:
  values = file.read().strip().split("\n")


def parse(values):
  return [[int(n) for n in l] for l in values]


def enlarge(m):
  def next(x, itr):
    return 9 if (x+itr) == 9 else (x+itr) % 9

  res = m.copy()
  for itr in range(1, 5):
    for l in m:
      res.append([next(x, itr) for x in l])
  res2 = []
  for l in res:
    ls = []
    for itr in range(5):
      ls += [next(x, itr) for x in l]
    res2.append(ls)

  return res2


def is_valid(li, ci, m):
  if li < 0 or not li < len(m):
    return False
  if ci < 0 or not ci < len(m[0]):
    return False

  return True


def path(m):
  djk = []
  pq = []
  for li in range(len(m)):
    djk.append([float('inf') for i in range(len(m[0]))])

  heapq.heappush(pq, (0, 0, 0))
  djk[0][0] = m[0][0]
  vis = {}

  while len(pq):
    d, li, ci = heapq.heappop(pq)
    if vis.get((li, ci)):
      continue
    vis[(li, ci)] = True
    for adj_li, adj_ci in [(li-1, ci), (li+1, ci), (li, ci+1), (li, ci-1)]:
      if not vis.get((adj_li, adj_ci)) and is_valid(adj_li, adj_ci, m):
        cost = d + m[adj_li][adj_ci]
        if cost < djk[adj_li][adj_ci]:
          heapq.heappush(pq, (cost, adj_li, adj_ci))
          djk[adj_li][adj_ci] = cost

  return djk[len(m)-1][len(m[0])-1]


def solve1(values):
  return path(parse(values))


def solve2(values):
  m = enlarge(parse(values))
  return path(m)


# print(solve2(values))

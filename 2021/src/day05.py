
with open("input/day05.txt", "r") as file:
  values = file.read().split("\n")


def get_lines(values):
  res = []

  for l in values:
    coord_strs = l.split(' -> ')
    start, end = list(map(lambda pair: pair.split(','), coord_strs))
    res.append({
        'start': (int(start[0]), int(start[1])),
        'end': (int(end[0]), int(end[1])),
    })

  return res


def is_straight(line):
  return line['start'][0] == line['end'][0] or line['start'][1] == line['end'][1]


def solve1(values):
  lines = list(filter(is_straight, get_lines(values)))
  count = 0
  m = {}
  for i in range(999):
    m[i] = {}
    for ci in range(999):
      m[i][ci] = 0

  for l in lines:
    if l['start'][0] == l['end'][0]:
      first = min(l['start'][1], l['end'][1])
      last = max(l['start'][1], l['end'][1])
      for i in range(first, last+1):
        if m[l['start'][0]][i] == 1:
          count += 1
        m[l['start'][0]][i] += 1
    else:
      first = min(l['start'][0], l['end'][0])
      last = max(l['start'][0], l['end'][0])
      for i in range(first, last+1):
        if m[i][l['start'][1]] == 1:
          count += 1
        m[i][l['start'][1]] += 1

  return count


def get_slope(line):
  return (line['end'][1] - line['start'][1]) / (line['end'][0] - line['start'][0])


def get_slope_intercept(line):
  slope = get_slope(line)
  intercept = line['start'][1] - (slope * line['start'][0])
  return lambda x: (slope * x) + intercept


def solve2(values):
  lines = get_lines(values)
  count = 0
  m = {}
  for i in range(999):
    m[i] = {}
    for ci in range(999):
      m[i][ci] = 0

  for l in lines:
    if l['start'][0] == l['end'][0]:
      first = min(l['start'][1], l['end'][1])
      last = max(l['start'][1], l['end'][1])
      for y in range(first, last+1):
        if m[l['start'][0]][y] == 1:
          count += 1
        m[l['start'][0]][y] += 1
    elif l['start'][1] == l['end'][1]:
      first = min(l['start'][0], l['end'][0])
      last = max(l['start'][0], l['end'][0])
      for x in range(first, last+1):
        if m[x][l['start'][1]] == 1:
          count += 1
        m[x][l['start'][1]] += 1
    else:
      first = min(l['start'][0], l['end'][0])
      last = max(l['start'][0], l['end'][0])
      fn = get_slope_intercept(l)
      for x in range(first, last+1):
        y = fn(x)
        if m[x][y] == 1:
          count += 1
        m[x][y] += 1

  return count


print(solve2(values))

with open("input/day01.txt", "r") as file:
  values = list(map(int, file.read().split("\n")))


def solve1(values):
  count = 0

  for i, n in enumerate(values):
    if i == 0:
      continue
    if n > values[i-1]:
      count += 1

  return count


def solve2(values):
  count = 0

  for i, n in enumerate(values):
    if i < 3:
      continue
    if n > values[i-3]:
      count += 1

  return count


# print(solve2(values))

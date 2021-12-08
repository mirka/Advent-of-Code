from math import ceil, inf
from statistics import mean, median

with open("input/day07.txt", "r") as file:
  values = file.read().split(",")
  values = list(map(int, values))


def solve1(values):
  pos = int(median(values))
  fuel = 0
  for n in values:
    fuel += abs(pos - n)

  return fuel


def solve2(values):
  res = inf
  for pos in range(min(values), max(values) + 1):
    fuel = 0

    for n in values:
      distance = abs(pos - n)
      fuel += (distance * (distance + 1)) / 2

    res = min(fuel, res)

  return int(res)


# print(solve2(values))

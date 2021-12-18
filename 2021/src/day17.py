import itertools
import re

with open("input/day17.txt", "r") as file:
  values = file.read().strip()


def parse(values):
  matches = re.search(
      r'target area: x=(\d+)\.\.(\d+), y=(-?\d+)\.\.(-?\d+)', values)
  return [int(matches.group(x)) for x in range(1, 5)]


def find_x(xmin):
  return int((xmin * 2) ** 0.5)


def max_y(y):
  return (y * (y + 1)) // 2


def solve1(values):
  target = parse(values)
  yvel = target[2] * -1 - 1
  return max_y(yvel)


def lands(xv, yv, target):
  x = 0
  y = 0
  for i in itertools.count():
    x += max(xv - i, 0)
    y += yv - i
    if (target[0] <= x <= target[1]) and (target[2] <= y <= target[3]):
      return True
    if x > target[1] or y < target[2]:
      return False


def solve2(values):
  target = parse(values)
  min_x = find_x(target[0])
  max_x = target[1]
  min_y = target[2]
  max_y = target[2] * -1 - 1

  return sum([lands(x, y, target) for x in range(min_x, max_x+1)
              for y in range(min_y, max_y+1)])


# print(solve2(values))

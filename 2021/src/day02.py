with open("input/day02.txt", "r") as file:
  values = file.read().split("\n")


def splitCmd(cmd):
  dir, n = cmd.split(' ')
  return (dir, int(n))


def parse(values):
  return list(map(splitCmd, values))


def solve1(values):
  horizontal = 0
  depth = 0

  for (dir, n) in parse(values):
    if dir == 'forward':
      horizontal += n
    if dir == 'up':
      depth -= n
    if dir == 'down':
      depth += n

  return horizontal * depth


def solve2(values):
  horizontal = 0
  depth = 0
  aim = 0

  for (dir, n) in parse(values):
    if dir == 'forward':
      horizontal += n
      depth += (aim * n)
    if dir == 'up':
      aim -= n
    if dir == 'down':
      aim += n

  return horizontal * depth


# print(solve2(values))

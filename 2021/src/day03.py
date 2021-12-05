from functools import reduce

with open("input/day03.txt", "r") as file:
  values = file.read().split("\n")


def get_gamma(values):
  res = ''

  for i in range(len(values[0])):
    sum = reduce(lambda a, b: a+b, map(lambda v: int(v[i]), values))
    res += '1' if sum > (len(values) / 2) else '0'

  return res


def solve1(values):
  gamma = int(get_gamma(values), 2)
  epsilon = ~gamma + (1 << len(values[0]))
  return gamma * epsilon


def find_rating(fn, values):
  ls = values
  for bi in range(len(values[0])):
    zeroes = []
    ones = []

    for v in ls:
      if v[bi] == '0':
        zeroes.append(v)
      else:
        ones.append(v)

    ls = fn(zeroes, ones)
    if len(ls) == 1:
      break

  return int(ls[0], 2)


def solve2(values):
  oxygen = find_rating(lambda a, b: a if len(a) > len(b) else b, values)
  co2 = find_rating(lambda a, b: a if len(a) <= len(b) else b, values)
  return oxygen * co2


# print(solve2(values))

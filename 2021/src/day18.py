import math
import re
import functools

with open("input/day18.txt", "r") as file:
  values = file.read().strip().split("\n")


def replace(string, val, dir):
  regex = r'\d+(?=\D+$)' if dir == 'left' else r'\d+'
  m = re.search(regex, string)
  if m:
    newval = val + int(m.group())
    string = string[:m.start()] + str(newval) + string[m.end():]
  return string


def explode(values):
  st = 0

  for i, c in enumerate(values):
    if c == '[':
      st += 1
    if c == ']':
      st -= 1
    if st == 5:
      before = values[:i]
      rest = values[i+1:].partition(']')
      p = eval(f'[{rest[0]}]')
      after = rest[-1]
      return replace(before, p[0], 'left') + '0' + replace(after, p[1], 'right')

  return values


def split(values):
  m = re.search(r'\d\d+', values)
  if m:
    val = int(m.group())
    newval = f'[{math.floor(val/2)}, {math.ceil(val/2)}]'
    values = values[:m.start()] + str(newval) + values[m.end():]
  return values


def explit(values):
  next = explode(values)
  while next != values:
    values = next
    next = explode(values)
  next = split(values)
  return explit(next) if next != values else values


def add(a, b):
  return f'[{a}, {b}]'


def add_reduce(values):
  res = functools.reduce(lambda x, y: explit(add(x, y)), values)
  return eval(res)


def magnitude(p):
  for i, el in enumerate(p):
    if type(el) != int:
      p[i] = magnitude(el)
  return p[0] * 3 + p[1] * 2


def solve1(values):
  return magnitude(add_reduce(values))


def solve2(values):
  res = 0
  for ai, a in enumerate(values):
    for bi, b in enumerate(values):
      if ai == bi:
        continue
      res = max(res, solve1([a, b]))
  return res


# print(solve2(values))

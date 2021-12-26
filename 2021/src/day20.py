import functools
import itertools

with open("input/day20.txt", "r") as file:
  values = file.read().strip().split("\n\n")


def prepare_input(input, defval='0'):
  input = [['0' if c == '.' else '1' for c in l] for l in input]
  input = [[defval, defval] + l + [defval, defval] for l in input]
  return [[defval]*len(input[0])]*2 + input + [[defval]*len(input[0])]*2


def enhance(algo, input):
  res = []
  for li in range(1, len(input[0])-1):
    res.append([])
    for ci in range(1, len(input)-1):
      val = ''.join(sum([input[i][ci-1:ci+2] for i in range(li-1, li+2)], []))
      res[li-1] += algo[int(val, 2)]
  return res


def core_solve(values, times):
  algo = values[0]
  input = values[1].splitlines()
  defval = '0'
  for _ in range(times):
    input = enhance(algo, prepare_input(input, defval))
    defval = '0' if algo[int(defval*9, 2)] == '.' else '1'
  return functools.reduce(lambda a, b: a + (0 if b == '.' else 1), itertools.chain.from_iterable(input), 0)


def solve1(values):
  return core_solve(values, 2)


def solve2(values):
  return core_solve(values, 50)


# print(solve1(values))

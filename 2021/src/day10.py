with open("input/day10.txt", "r") as file:
  values = file.read().strip().split("\n")


def solve1(values):
  res = 0

  for l in values:
    stack = []
    for c in l:
      if c in ['(', '[', '{', '<']:
        stack.append(c)
      elif abs(ord(stack.pop()) - ord(c)) > 2:
        res += [3, 57, 1197, 25137][[')', ']', '}', '>'].index(c)]

  return res


def score(stack):
  score = 0
  for c in reversed(stack):
    score *= 5
    score += [None, '(', '[', '{', '<'].index(c)
  return score


def solve2(values):
  scores = []
  for l in values:
    stack = []
    for c in l:
      if c in ['(', '[', '{', '<']:
        stack.append(c)
      elif abs(ord(stack.pop()) - ord(c)) > 2:
        stack = []
        break
    if len(stack):
      scores.append(score(stack))

  med = int((len(scores) - 1)/2)
  return sorted(scores)[med]


# print(solve2(values))

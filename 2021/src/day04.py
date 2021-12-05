
seq = '85,84,30,15,46,71,64,45,13,90,63,89,62,25,87,68,73,47,65,78,2,27,67,95,88,99,96,17,42,31,91,98,57,28,38,93,43,0,55,49,22,24,82,54,59,52,3,26,9,32,4,48,39,50,80,21,5,1,23,10,58,34,12,35,74,8,6,79,40,76,86,69,81,61,14,92,97,19,7,51,33,11,77,75,20,70,29,36,60,18,56,37,72,41,94,44,83,66,16,53'

with open("input/day04.txt", "r") as file:
  boards = file.read().split("\n\n")


def get_map(seq):
  res = {}
  for i, n in enumerate(seq):
    if not n in res:
      res[n] = i
  return res


def board_to_lines(board):
  m = list(map(lambda l: list(map(lambda n: int(n), l.split())),
           board.strip().split('\n')))
  res = list(m)

  for i in range(5):
    res.append(list(map(lambda l: l[i], m)))

  return res


def fastest_bingo(lines, m):
  res = len(m) - 1

  for l in lines:
    bingo = 0
    for n in l:
      bingo = max(bingo, m[n])
    res = min(res, bingo)

  return res


def get_score(board, m, bingo):
  score = 0
  for n in board.split():
    intn = int(n)
    if m[intn] > bingo:
      score += intn
  return score


def solve1(seq, boards):
  s = list(map(int, seq.split(',')))
  m = get_map(s)

  fastest = len(m)

  for b in boards:
    res = fastest_bingo(board_to_lines(b), m)
    if res < fastest:
      fastest = res
      fastest_board = b

  return get_score(fastest_board, m, fastest) * s[fastest]


def solve2(seq, boards):
  s = list(map(int, seq.split(',')))
  m = get_map(s)

  last = 0

  for b in boards:
    res = fastest_bingo(board_to_lines(b), m)
    if res > last:
      last = res
      last_board = b

  return get_score(last_board, m, last) * s[last]


# print(solve2(seq, boards))

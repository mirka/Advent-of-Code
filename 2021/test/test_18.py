from src.day18 import solve1, solve2, explode, split, explit, add_reduce, magnitude

values = """
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
""".strip().split('\n')

values2 = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
""".strip().split('\n')


def test_solve1():
  assert explode('[[[[[9, 8], 1], 2], 3], 4]') == '[[[[0, 9], 2], 3], 4]'
  assert explode('[7, [6, [5, [4, [3, 2]]]]]') == '[7, [6, [5, [7, 0]]]]'
  assert explode('[[6, [5, [4, [3, 2]]]], 1]') == '[[6, [5, [7, 0]]], 3]'
  assert explode(
      '[[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]]') == '[[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]'
  assert explode(
      '[[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]') == '[[3, [2, [8, 0]]], [9, [5, [7, 0]]]]'
  assert split(
      '[[[[0, 7], 4], [15, [0, 13]]], [1, 1]]') == '[[[[0, 7], 4], [[7, 8], [0, 13]]], [1, 1]]'
  assert explit(
      '[[[[[4, 3], 4], 4], [7, [[8, 4], 9]]], [1, 1]]') == '[[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]]'
  assert add_reduce(
      values) == [[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]]
  assert magnitude([[1, 2], [[3, 4], 5]]) == 143
  assert solve1(values2) == 4140


def test_solve2():
  assert solve2(values2) == 3993

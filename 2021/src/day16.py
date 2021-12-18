import functools
import operator

with open("input/day16.txt", "r") as file:
  values = file.read().strip()


def hexbin(char):
  num = ord(char) - ord('A') + \
      10 if ord(char) >= ord('A') else ord(char) - ord('0')
  return format(num, '04b')


def consume_header(bits):
  return bits[6:], int(bits[:3], 2), int(bits[3:6], 2)


vsum = 0


def consume_packet(bits):
  global vsum
  literal = 0
  ops = {
      0: operator.add,
      1: operator.mul,
      2: min,
      3: max,
      5: operator.gt,
      6: operator.lt,
      7: operator.eq,
  }

  bits, version, typeid = consume_header(bits)
  vsum += version
  if typeid == 4:
    bits, literal = consume_literal(bits)
  else:
    bits, literal = consume_operator(bits, ops[typeid])

  return bits, literal


def consume_literal(bits):
  btstr = ''
  while bits[0] == '1':
    btstr += bits[1:5]
    bits = bits[5:]
  btstr += bits[1:5]
  bits = bits[5:]
  return bits, int(btstr, 2)


def consume_operator(bits, op):
  lengthtype = bits[0]
  bits = bits[1:]
  vals = []

  if lengthtype == '0':
    bitlength = int(bits[:15], 2)
    bits = bits[15:]
    b = bits[:bitlength]

    while len(b) and int(b, 2) > 0:
      b, val = consume_packet(b)
      vals.append(val)

    bits = bits[bitlength:]
  else:
    packets = int(bits[:11], 2)
    bits = bits[11:]
    for _ in range(packets):
      bits, val = consume_packet(bits)
      vals.append(val)

  return bits, functools.reduce(op, vals)


def solve1(values):
  global vsum
  bits = ''.join([hexbin(c) for c in values])
  vsum = 0
  consume_packet(bits)
  return vsum


def solve2(values):
  bits = ''.join([hexbin(c) for c in values])
  bits, literal = consume_packet(bits)
  return literal


# print(solve2(values))

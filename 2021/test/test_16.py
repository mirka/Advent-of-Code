from src.day16 import solve1, solve2


def test_solve1():
  assert solve1("D2FE28") == 6
  assert solve1("38006F45291200") == 1 + 6 + 2
  assert solve1("EE00D40C823060") == 7 + 2 + 4 + 1
  assert solve1("8A004A801A8002F478") == 16
  assert solve1("620080001611562C8802118E34") == 12
  assert solve1("C0015000016115A2E0802F182340") == 23
  assert solve1("A0016C880162017C3686B18A3D4780") == 31


def test_solve2():
  assert solve2("C200B40A82") == 3
  assert solve2("04005AC33890") == 54
  assert solve2("880086C3E88112") == 7
  assert solve2("CE00C43D881120") == 9
  assert solve2("D8005AC2A8F0") == 1
  assert solve2("F600BC2D8F") == 0
  assert solve2("9C005AC2F8F0") == 0
  assert solve2("9C0141080250320F1802104A08") == 1

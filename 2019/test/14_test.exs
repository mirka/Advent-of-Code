defmodule Day14Test do
  use ExUnit.Case
  import Day14
  require Day14_Parser

  test "Parse row" do
    assert Day14_Parser.parse_row("2 AB, 3 BC, 4 CA => 1 FUEL") === %{
             "FUEL" => %{deps: [{"AB", 2}, {"BC", 3}, {"CA", 4}], quantity: 1}
           }
  end

  test "Parse input" do
    input = "10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL"

    assert Day14_Parser.parse(input) === %{
             "A" => %{deps: [{"ORE", 10}], quantity: 10},
             "B" => %{deps: [{"ORE", 1}], quantity: 1},
             "C" => %{deps: [{"A", 7}, {"B", 1}], quantity: 1},
             "D" => %{deps: [{"A", 7}, {"C", 1}], quantity: 1},
             "E" => %{deps: [{"A", 7}, {"D", 1}], quantity: 1},
             "FUEL" => %{deps: [{"A", 7}, {"E", 1}], quantity: 1}
           }
  end

  test "Get quantity to produce" do
    assert get_quantity_to_produce(5, 3) === 2
    assert get_quantity_to_produce(3, 5) === 0
    assert get_quantity_to_produce(3, 0) === 3
  end

  test "Get dependencies (simple)" do
    recipes = %{
      "A" => %{deps: [{"ORE", 10}], quantity: 10}
    }

    assert get_deps_for_chemical(recipes, "ORE", 10) |> elem(0) === %{"ORE" => 10}
    assert get_deps_for_chemical(recipes, "A", 2) |> elem(0) === %{"ORE" => 10}
    assert get_deps_for_chemical(recipes, "A", 15) |> elem(0) === %{"ORE" => 20}
  end

  test "Get total ORE for deps" do
    recipes = %{
      "A" => %{deps: [{"ORE", 10}], quantity: 10},
      "B" => %{deps: [{"ORE", 1}], quantity: 1},
      "C" => %{deps: [{"A", 7}, {"B", 1}], quantity: 1}
    }

    assert get_total_ore_for_deps(%{"A" => 7, "B" => 1}, recipes) |> elem(0) === 11
    assert get_total_ore_for_deps(%{"A" => 13, "B" => 2}, recipes) |> elem(0) === 22
  end

  test "Get total ORE for deps (nested)" do
    recipes = %{
      "A" => %{deps: [{"ORE", 10}], quantity: 10},
      "B" => %{deps: [{"ORE", 1}], quantity: 1},
      "C" => %{deps: [{"A", 7}, {"B", 1}], quantity: 1}
    }

    assert get_total_ore_for_deps(%{"A" => 7, "C" => 1}, recipes) |> elem(0) === 21
  end

  test "Get total ORE for deps (reuse)" do
    recipes = %{
      "A" => %{deps: [{"ORE", 10}], quantity: 10},
      "B" => %{deps: [{"ORE", 1}], quantity: 1},
      "C" => %{deps: [{"A", 7}, {"B", 1}], quantity: 1}
    }

    assert get_total_ore_for_deps(%{"A" => 3, "C" => 1}, recipes) |> elem(0) === 11
  end

  test "Get total ORE for deps (deep 1)" do
    recipes = %{
      "A" => %{deps: [{"ORE", 10}], quantity: 10},
      "B" => %{deps: [{"ORE", 1}], quantity: 1},
      "C" => %{deps: [{"A", 7}, {"B", 1}], quantity: 1},
      "D" => %{deps: [{"A", 7}, {"C", 1}], quantity: 1},
      "E" => %{deps: [{"A", 7}, {"D", 1}], quantity: 1},
      "FUEL" => %{deps: [{"A", 7}, {"E", 1}], quantity: 1}
    }

    assert get_total_ore_for_deps(%{"FUEL" => 1}, recipes) |> elem(0) === 31
  end

  test "Get total ORE for deps (deep 2)" do
    input = "9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL"

    assert solve1(input) === 165
  end

  test "Get total ORE for deps (deep 3)" do
    input = "157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"

    assert solve1(input) === 13312
  end

  test "Get total ORE for deps (deep 4)" do
    input = "171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX"

    assert solve1(input) === 2_210_736
  end

  test "Max fuel 1" do
    input = "157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"

    assert solve2(input) === 82_892_753
  end

  test "Max fuel 2" do
    input = "171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX"

    assert solve2(input) === 460_664
  end
end

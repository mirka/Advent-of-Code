{:ok, input} = File.read("inputs/14.txt")

defmodule Day14_Parser do
  def parse(input) do
    String.split(input, "\n")
    |> Enum.map(&parse_row/1)
    |> Enum.reduce(%{}, fn chemical, all_chemicals ->
      Map.merge(all_chemicals, chemical)
    end)
  end

  def parse_chemical(string) do
    [quantity, chemical] = String.split(string, " ", trim: true)
    {integer, _} = Integer.parse(quantity)
    {chemical, integer}
  end

  def parse_row(row) do
    [deps, product] =
      String.split(row, "=>")
      |> List.update_at(0, fn items ->
        String.split(items, ",")
        |> Enum.map(&parse_chemical/1)
      end)

    {chemical, quantity} = parse_chemical(product)

    %{
      chemical => %{
        quantity: quantity,
        deps: deps
      }
    }
  end
end

defmodule Day14 do
  def get_quantity_to_produce(needed, stocked) when stocked >= needed, do: 0
  def get_quantity_to_produce(needed, stocked), do: needed - stocked

  def get_deps_for_chemical(recipes, chemical, quantity, stock \\ %{})

  def get_deps_for_chemical(_, "ORE", quantity, stock) do
    {%{"ORE" => quantity}, stock}
  end

  def get_deps_for_chemical(recipes, chemical, quantity, stock) do
    %{deps: deps, quantity: unit_quantity} = recipes[chemical]

    quantity_to_produce = get_quantity_to_produce(quantity, Map.get(stock, chemical, 0))
    multiplier = ceil(quantity_to_produce / unit_quantity)
    remaining = unit_quantity * multiplier - quantity_to_produce
    stock_adjustment = quantity_to_produce + remaining - quantity

    updated_stock = Map.update(stock, chemical, stock_adjustment, &(&1 + stock_adjustment))

    deps_map = for {dep, dep_quantity} <- deps, into: %{}, do: {dep, dep_quantity * multiplier}
    {deps_map, updated_stock}
  end

  def merge_deps(list) do
    Enum.reduce(list, %{}, fn deps, total_deps ->
      Map.merge(deps, total_deps, fn _, a, b -> a + b end)
    end)
  end

  def get_total_ore_for_deps(deps, recipes, stock \\ %{}) do
    {next_deps, next_stock} =
      Enum.reduce(deps, {[], stock}, fn {chemical, quantity}, {all_deps, current_stock} ->
        {this_deps, this_stock} =
          get_deps_for_chemical(recipes, chemical, quantity, current_stock)

        {all_deps ++ [this_deps], this_stock}
      end)

    merged_deps = merge_deps(next_deps)

    if Map.keys(merged_deps) |> length() === 1 && Map.get(merged_deps, "ORE") do
      {merged_deps["ORE"], next_stock}
    else
      get_total_ore_for_deps(merged_deps, recipes, next_stock)
    end
  end

  def max_fuel(recipes) do
    get_total_ore_for_deps(%{"FUEL" => 1}, recipes)
  end

  def multiply_stock(stock, multiplier) do
    for {chemical, quantity} <- stock, into: %{}, do: {chemical, quantity * multiplier}
  end

  def get_estimate_fuel(ore_available, ore_per_fuel) do
    (ore_available / ore_per_fuel) |> floor()
  end

  def calculate_max_fuel(recipes, ore_available, ore_per_fuel, stock, total \\ 0) do
    estimate_fuel = get_estimate_fuel(ore_available, ore_per_fuel)

    if estimate_fuel < 1 do
      total
    else
      {ore_used, stock_left} = get_total_ore_for_deps(%{"FUEL" => estimate_fuel}, recipes, stock)
      ore_left = ore_available - ore_used

      calculate_max_fuel(recipes, ore_left, ore_per_fuel, stock_left, total + estimate_fuel)
    end
  end

  def solve1(input) do
    recipes = Day14_Parser.parse(input)

    get_total_ore_for_deps(%{"FUEL" => 1}, recipes)
    |> elem(0)
  end

  def solve2(input) do
    recipes = Day14_Parser.parse(input)
    {ore_per_fuel, _} = get_total_ore_for_deps(%{"FUEL" => 1}, recipes)

    calculate_max_fuel(recipes, 1_000_000_000_000, ore_per_fuel, %{})
  end
end

# Day14.solve2(input)
# |> IO.inspect()

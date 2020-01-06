{:ok, input} = File.read("inputs/01.txt")

masses = String.split(input) |> Enum.map(&String.to_integer/1)

defmodule Fuel do
  def calculate(mass) do
    Integer.floor_div(mass, 3) - 2
  end

  # Add up fuel needed for fuel, recursively
  def calculate_entire(mass, total) do
    fuel = calculate(mass)

    if fuel > 0 do
      total + fuel + calculate_entire(fuel, total)
    else
      total
    end
  end
end

defmodule Day01 do
  def solve1(masses) do
    Enum.reduce(masses, 0, fn mass, total ->
      fuel = Integer.floor_div(mass, 3) - 2
      total + fuel
    end)
  end

  def solve2(masses) do
    Enum.reduce(masses, 0, fn mass, total ->
      total + Fuel.calculate_entire(mass, 0)
    end)
  end
end

# IO.puts(Day01.solve1(masses))
# IO.puts(Day01.solve2(masses))

{:ok, input} = File.read("01-input.txt")

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

Enum.reduce(masses, 0, fn mass, total ->
  total + Fuel.calculate_entire(mass, 0)
end)
|> IO.puts()

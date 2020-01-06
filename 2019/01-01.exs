{:ok, input} = File.read("01-input.txt")

masses = String.split(input) |> Enum.map(&String.to_integer/1)

Enum.reduce(masses, 0, fn mass, total ->
  fuel = Integer.floor_div(mass, 3) - 2
  total + fuel
end)
|> IO.puts()

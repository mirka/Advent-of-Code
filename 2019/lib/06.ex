{:ok, input} = File.read("inputs/06.txt")

defmodule Day06 do
  def parse_input(input) do
    String.split(input, "\n")
    |> Enum.map(fn row -> String.split(row, ")") end)
  end

  def build_map(list) do
    Enum.reduce(list, %{}, fn [parent, child], map ->
      Map.put_new(map, child, %{parent: parent})
    end)
  end

  def get_orbit_count(_, start_at) when start_at === "COM" do
    0
  end

  def get_orbit_count(map, start_at) do
    node = map[start_at]
    count = Map.get(node, :count)

    cond do
      count !== nil -> count
      node.parent === "COM" -> 1
      true -> get_orbit_count(map, node.parent) + 1
    end
  end

  def append_orbit_counts(map) do
    Enum.reduce(map, map, fn {node_key, _}, new_map ->
      count = get_orbit_count(new_map, node_key)

      new_node = Map.put_new(new_map[node_key], :count, count)

      Map.put(new_map, node_key, new_node)
    end)
  end

  def sum_counts(map) do
    Enum.reduce(map, 0, fn {_, %{count: count}}, sum ->
      sum + count
    end)
  end

  def solve1(input) do
    parse_input(input)
    |> build_map
    |> append_orbit_counts
    |> sum_counts
  end
end

Day06.solve1(input)
|> IO.inspect()

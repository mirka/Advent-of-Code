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

  def get_parents(map, start_at, parents \\ []) do
    if start_at === "COM" do
      parents
    else
      parent = map[start_at].parent
      get_parents(map, parent, parents ++ [parent])
    end
  end

  def find_transfers_to_common_parent(map) do
    you = get_parents(map, "YOU")
    santa = get_parents(map, "SAN")

    Enum.find_value(you, fn you_node ->
      santa_transfers =
        Enum.find_index(santa, fn santa_node ->
          you_node === santa_node
        end)

      if santa_transfers do
        you_transfers = Enum.find_index(you, fn node -> node === you_node end)
        santa_transfers + you_transfers
      end
    end)
  end

  def solve1(input) do
    parse_input(input)
    |> build_map
    |> append_orbit_counts
    |> sum_counts
  end

  def solve2(input) do
    parse_input(input)
    |> build_map
    |> find_transfers_to_common_parent
  end
end

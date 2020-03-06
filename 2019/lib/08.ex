{:ok, input} = File.read("inputs/08.txt")

defmodule Day08 do
  def chunk_input(input, count) do
    input
    |> String.splitter("", trim: true)
    |> Stream.chunk_every(count)
  end

  def compose_layers(top, bottom) when length(top) === 0 do
    bottom
  end

  def compose_layers(top, bottom) do
    Enum.reduce(top, {bottom, []}, fn top_pixel, {[bottom_pixel | bottom_rest], result} ->
      resulting_pixel = if top_pixel === "2", do: bottom_pixel, else: top_pixel
      {bottom_rest, result ++ [resulting_pixel]}
    end)
    |> elem(1)
  end

  def print(pixels, width) do
    Stream.chunk_every(pixels, width)
    |> Enum.reduce("", fn chunk, result ->
      result <> Enum.join(chunk) <> "\n"
    end)
    |> String.trim_trailing()
  end

  def print_legible(pixels, width) do
    Stream.chunk_every(pixels, width)
    |> Enum.reduce("", fn chunk, result ->
      string =
        Enum.join(chunk)
        |> String.replace("0", " ")
        |> String.replace("1", "0")

      result <> string <> "\n"
    end)
    |> String.trim_trailing()
  end

  def solve1(layers) do
    layers
    |> Enum.reduce(%{"0": :infinity}, fn layer, lowest ->
      freqs = Enum.frequencies(layer)
      if freqs["0"] < lowest["0"], do: freqs, else: lowest
    end)
    |> (fn freqs -> freqs["1"] * freqs["2"] end).()
  end

  def solve2(layers) do
    layers
    |> Enum.reduce([], fn layer, composite ->
      compose_layers(composite, layer)
    end)
  end
end

# Day08.chunk_input(input, 25 * 6)
# |> Day08.solve2()
# |> Day08.print_legible(25)
# |> IO.puts()

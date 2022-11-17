defmodule Day9 do
  use Utils.DayBoilerplate, day: 9

  def sample_input do
    """
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
    """
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " = "))
    |> Enum.map(fn [a, b] -> [String.split(a, " to "), b] end)
    |> Enum.flat_map(fn [[a, b], c] ->
      [
        {String.to_atom(a), String.to_atom(b), weight: String.to_integer(c)},
        {String.to_atom(b), String.to_atom(a), weight: String.to_integer(c)}
      ]
    end)
  end

  def get_shortest_path_cost(g, a, b) do
    Graph.dijkstra(g, a, b)
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn
      [a, b] -> true
      c -> false
    end)
    |> Enum.map(fn [a, b] -> Graph.edge(g, a, b) end)
    |> Enum.map(fn e -> e.weight end)
    |> Enum.sum()
  end

  def solve(input) do
    p =
      input
      |> Enum.reduce(%{}, fn {a, b, weight: w}, acc -> Map.put(acc, {a, b}, w) end)

    cities = input |> Enum.flat_map(fn {a, b, _} -> [a, b] end) |> MapSet.new()

    cities
    |> Comb.permutations()
    |> Enum.map(fn comb ->
      comb
      |> Enum.chunk_every(2, 1)
      |> Enum.map(fn
        [a, b] -> Map.get(p, {a, b}, 0)
        c -> 0
      end)
      |> Enum.sum()
    end)
    |> Enum.min_max()
  end
end

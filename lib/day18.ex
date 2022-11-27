defmodule Day18 do
  use Utils.DayBoilerplate, day: 18
  use Memoize

  def sample_input do
    """
    .#.#.#
    ...##.
    #....#
    ..#...
    #.#..#
    ####..
    """
  end

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&Utils.split_each_char/1)
    |> Utils.list_of_lists_to_map_by_point()
  end

  def solve(input) do
    Utils.do_times(&tick/1, input, 100)
    |> Map.values()
    |> Enum.count(fn x -> x == "#" end)
  end

  def solve2(input) do
    Utils.do_times(&tick2/1, input, 100)
    |> Map.values()
    |> Enum.count(fn x -> x == "#" end)
  end

  defmemo sizes(map) do
    size_x = map |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    size_y = map |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    {size_x, size_y}
  end

  def ensure_corners_lit(map) do
    {x, y} = sizes(map)
    [{0, 0}, {x, 0}, {0, y}, {x, y}]
    |> Enum.reduce(map, fn x, acc -> Map.put(acc, x, "#") end)
  end

  def neighbors({x, y}) do
    [
      {-1, -1},
      {1, 1},
      {-1, 1},
      {1, -1},
      {0, -1},
      {-1, 0},
      {0, 1},
      {1, 0}
    ]
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
  end

  def tick2(map) do
    map
    |> tick
    |> ensure_corners_lit
  end

  def tick(map) do
    map
    |> Map.to_list()
    |> Enum.map(fn {k, v} ->
      lit_neighbors =
        neighbors(k)
        |> Enum.map(&Map.get(map, &1, "."))
        |> Enum.filter(fn x -> x == "#" end)
        |> length()

      new_val = case {lit_neighbors, v} do
        {2, "#"} -> "#"
        {3, _} -> "#"
        _ -> "."
      end

      {k, new_val}
    end)
    |> Map.new()
  end
end

defmodule Day6 do
  @moduledoc false

  def real_input do
    Utils.get_input(6, 1)
  end

  def sample_input do
    """
    turn on 0,0 through 999,999
    """
  end

  def sample_input2 do
    """
    """
  end

  def sample do
    sample_input()
    |> parse_input1
    |> solve1
  end

  def part1 do
    real_input1()
    |> parse_input1
    |> solve1
  end

  def sample2 do
    sample_input2()
    |> parse_input2
    |> solve2
  end

  def part2 do
    real_input2()
    |> parse_input2
    |> solve2
  end

  def real_input1, do: real_input()
  def real_input2, do: real_input()


  def parse_input1(input), do: parse_input(input)
  def parse_input2(input), do: parse_input(input)

  def solve1(input), do: solve(input)

  def parse_and_solve1(input), do: parse_input1(input) |> solve1
  def parse_and_solve2(input), do: parse_input2(input) |> solve2

  def parse_range(range) do
    pattern = ~r/(\d+),(\d+) through (\d+),(\d+)/
    [x1, y1, x2, y2] = Regex.run(pattern, range, capture: :all_but_first) |> Enum.map(&String.to_integer/1)
    {{x1, y1}, {x2, y2}}
  end

  def parse_line("turn on " <> rest), do: {:on, parse_range(rest)}
  def parse_line("turn off " <> rest), do: {:off, parse_range(rest)}
  def parse_line("toggle " <> rest), do: {:toggle, parse_range(rest)}

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_line/1)
  end

  def points_for_range({{x1, y1}, {x2, y2}}) do
    for x <- x1..x2, y <- y1..y2, do: {x, y}
  end

  def update_grid({:on, range}, grid) do
    do_update_grid(grid, fn x -> true end, range)
  end

  def update_grid({:off, range}, grid) do
    do_update_grid(grid, fn x -> false end, range)
  end

  def update_grid({:toggle, range}, grid) do
    do_update_grid(grid, fn x -> !x end, range)
  end

  def do_update_grid(grid, func, range, default \\ false) do
    range
    |> points_for_range
    |> Enum.map(fn p -> {p, Map.get(grid, p, default)} end)
    |> Enum.reduce(grid, fn {p, v}, acc -> Map.put(acc, p, func.(v)) end)
  end

  def solve(input) do
    input
    |> Enum.reduce(%{}, &update_grid/2)
    |> Map.values()
    |> Enum.filter(&(&1))
    |> Enum.count()
  end

  def update_grid_redux({:on, range}, grid) do
    do_update_grid(grid, &(&1 + 1), range, 0)
  end

  def update_grid_redux({:off, range}, grid) do
    do_update_grid(grid, &(Utils.at_least(&1 - 1, 0)), range, 0)
  end

  def update_grid_redux({:toggle, range}, grid) do
    do_update_grid(grid, &(&1 + 2), range, 0)
  end

  def solve2(input) do
    input
    |> Enum.reduce(%{}, &update_grid_redux/2)
    |> Map.values()
    |> Enum.sum()
  end

end

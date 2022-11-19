defmodule Day13 do
  use Utils.DayBoilerplate, day: 13

  def sample_input do
    """
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
    """
  end

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_line/1)
  end

  @pattern ~r/(\w+) would (\w+) (\d+) happiness units by sitting next to (\w+).*/
  def parse_line(line) do
    [[h | t] | _] = Regex.scan(@pattern, line)
    [p1, gl, amount, p2] = t
    sign = if gl == "gain", do: 1, else: -1
    {p1, p2, sign * String.to_integer(amount)}
  end

  def get_possible_seating_arrangements(input) do
    input
    |> Enum.flat_map(fn {a, b, _} -> [a, b] end)
    |> MapSet.new()
    |> Comb.permutations()
    |> Enum.to_list()
  end

  def get_happiness_map(input) do
    input |> Enum.map(fn {a, b, c} -> {a <> b, c} end) |> Map.new()
  end

  def score_arrangement(arrangement, happiness_map) do
    Stream.cycle(arrangement)
    |> Stream.chunk_every(2, 1)
    |> Stream.take(length(arrangement))
    |> Enum.to_list()
    |> Enum.map(&score_pair(&1, happiness_map))
    |> Enum.sum()
  end

  def score_pair([a, b], hm) do
    Map.get(hm, a <> b) + Map.get(hm, b <> a)
  end

  def solve(input) do
    happiness_map = input |> get_happiness_map

    input
    |> get_possible_seating_arrangements
    |> Enum.map(&score_arrangement(&1, happiness_map))
    |> Enum.max()
  end

  def add_me_to_options(input) do
    my_mappings = input
    |> Enum.flat_map(fn {a, b, _} -> [a, b] end)
    |> MapSet.new()
    |> Enum.flat_map(fn a -> [{"Donnie", a, 0}, {a, "Donnie", 0}] end)

    input ++ my_mappings
  end

  def solve2(input) do
    input
    |> add_me_to_options
    |> solve
  end
end

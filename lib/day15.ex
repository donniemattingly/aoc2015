defmodule Day15 do
  use Utils.DayBoilerplate, day: 15

  def sample_input do
    """
    Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
    Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
    """
  end

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    pattern =
      ~r/(?<name>\w+): capacity (?<capacity>[-|\d]+), durability (?<durability>[-|\d]+), flavor (?<flavor>[-|\d]+), texture (?<texture>[-|\d]+), calories (?<calories>[-|\d]+)/

    Regex.named_captures(pattern, line)
    |> Map.to_list()
    |> Enum.map(fn
      {"name", v} -> {"name", v}
      {k, v} -> {k, String.to_integer(v)}
    end)
    |> Map.new()
  end

  def calc(ingredients, amounts) do
    ["capacity", "durability", "flavor", "texture"]
    |> Enum.map(fn key ->
      Enum.map(ingredients, &{&1["name"], &1[key]})
      |> Enum.map(fn {name, value} -> value * amounts[name] end)
      |> Enum.sum()
    end)
    |> Enum.map(fn
      x when x < 0 -> 0
      x -> x
    end)
    |> Enum.reduce(&Kernel.*/2)
  end

  def calc2(ingredients, amounts) do
    ["capacity", "durability", "flavor", "texture"]
    |> Enum.map(fn key ->
      Enum.map(ingredients, &{&1["name"], &1[key], &1["calories"]})
      |> Enum.map(fn {name, value, calories} -> {value * amounts[name], calories * amounts[name]} end)
      |> Enum.reduce(fn {xtsp, xcal}, {atsp, acal} ->
        {xtsp + atsp, xcal + acal}
      end)
    end)
    |> IO.inspect
    |> Enum.map(fn
      {x, c} when x <= 0 -> 0
      {x, c} when c != 500 -> 0
      {x, c} -> x
    end)
    |> Enum.reduce(&Kernel.*/2)
  end

  def get_potential_combinations(num, sum) do
    Comb.combinations(1..sum, num) |> Stream.filter(fn x -> Enum.sum(x) == sum end)
  end

  def get_permuted_amounts(comb, ingredients) do
    opts = ingredients |> Enum.map(&Map.get(&1, "name"))

    Comb.permutations(comb)
    |> Enum.map(fn perm ->
      Enum.zip(opts, perm)
      |> Map.new()
    end)
  end

  def solve(input) do
    input
    |> length
    |> get_potential_combinations(100)
    |> Enum.flat_map(&get_permuted_amounts(&1, input))
    |> Utils.Parallel.pmap(&calc(input, &1))
    |> Enum.max()
  end

  def solve2(input) do
    input
    |> length
    |> get_potential_combinations(100)
    |> Enum.flat_map(&get_permuted_amounts(&1, input))
    |> Utils.Parallel.pmap(&calc2(input, &1))
    |> Enum.max()
  end
end

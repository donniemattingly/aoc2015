defmodule Day17 do
  use Utils.DayBoilerplate, day: 17

  def sample_input do
    """
    20
    15
    10
    5
    5
    """
  end

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&String.to_integer/1)
  end

  def get_possible_containers() do

  end

  def do_get_possible_containers(containers) do
    sum = Enum.sum(containers)
  end

  def solve(input) do
    l = input
    |> Enum.with_index()
    |> Comb.subsets
    |> Stream.filter(fn set -> set |> Enum.map(&elem(&1, 0)) |> Enum.sum() == 150 end)
    |> Enum.to_list()

    min_size = Enum.map(l, &length/1) |> Enum.min()

    l
    |> Enum.filter(fn s -> length(s) == min_size end)
    |> length
  end
end

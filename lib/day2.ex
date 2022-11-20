defmodule Day2 do
  @moduledoc false

  def real_input do
    Utils.get_input(2, 1)
  end

  def sample_input do
    """
    2x3x4
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

  def parse_line(line) do
    line |> String.split("x") |> Enum.map(&Integer.parse/1) |> Enum.map(&elem(&1, 0))
  end

  def parse_input(input) do
    input |> Utils.split_lines() |> Enum.map(&parse_line/1)
  end

  def paper_for_package([l, w, h]) do
    sides = [l * w, w * h, h * l]
    min = Enum.min(sides)
    Enum.reduce(sides, min, fn x, acc -> 2 * x + acc end)
  end

  def perimeter({s1, s2}) do
    2 * (s1 + s2)
  end

  def volume(l, w, h) do
    l * w * h
  end

  def ribbon_for_package([l, w, h]) do
    perimeter = [{l, w}, {w, h}, {h, l}] |> Enum.map(&perimeter/1) |> Enum.min()
    perimeter + volume(l, w, h)
  end

  def solve(input) do
    input |> Enum.map(&paper_for_package/1) |> Enum.sum()
  end

  def solve2(input) do
    input |> Enum.map(&ribbon_for_package/1) |> Enum.sum()
  end
end

defmodule Day1 do
  @moduledoc false

  def real_input do
    Utils.get_input(1, 1)
  end

  def sample_input do
    """
    (())
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

  def is_paren("("), do: true
  def is_paren(")"), do: true
  def is_paren(char), do: false

  def parse_input(input) do
    input |> String.split("") |> Enum.filter(&is_paren(&1))
  end

  def accumulator("(", acc), do: acc + 1
  def accumulator(")", acc), do: acc - 1

  def solve(input) do
    input
    |> Enum.reduce(0, &accumulator/2)
  end

  def accum("(", {acc, count}), do: {:cont, {acc + 1, count + 1}}
  def accum(")", {0, count}), do: {:halt, count + 1}
  def accum(")", {acc, count}), do: {:cont, {acc - 1, count + 1}}

  def solve2(input) do
    input
    |> Enum.reduce_while({0, 0}, &accum/2)
  end
end

defmodule Day8 do
  @moduledoc false

  def real_input do
    Utils.get_input(8, 1)
  end

  def sample_input do
    Utils.get_input(8, 3)
  end

  def sample_input2 do
    Utils.get_input(8, 3)
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

  def parse_and_solve1(input),
    do:
      parse_input1(input)
      |> solve1

  def parse_and_solve2(input),
    do:
      parse_input2(input)
      |> solve2

  def parse_input(input) do
    input
    |> Utils.split_lines()
  end

  def string_code_size(str) do
    String.length(str)
  end

  def in_memory_size(str) do
    str
    |> String.trim("\"")
    |> String.replace("\\\\", "*")
    |> String.replace("\\\"", "*")
    |> String.replace(~r/\\x[0-9a-f][0-9a-f]/, "*")
    |> IO.inspect()
    |> String.length()
  end

  def encoded_size_lol(str) do
    str
    |> IO.inspect()
    |> String.replace("\\\"", "1111")
    |> String.replace("\"", "222")
    |> String.replace("\\x", "333")
    |> String.replace("\\\\", "4444")
    |> IO.inspect()
    |> String.length()
  end

  def encoded_size(str) do
    str
    |> to_charlist
    |> Enum.map(fn
      34 -> [92, 34]
      92 -> [92, 92]
      x -> x
    end)
    |> List.flatten()
    |> IO.inspect()
    |> Enum.count()
    |> Kernel.+(2)
  end

  def fancy(str) do
    graphemes =
      str
      |> String.graphemes()

    Enum.count(graphemes, &(&1 == "\"")) + 2 * Enum.count(graphemes, &(&1 == "\\"))
  end

  def solve(input) do
    input
    |> Enum.map(fn str ->
      string_code_size(str) - in_memory_size(str)
    end)
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> Enum.map(fn str ->
      encoded_size(str) - string_code_size(str)
    end)
    |> Enum.sum()
  end
end

defmodule Day5 do
  @moduledoc false

  def real_input do
    Utils.get_input(5, 1)
  end

  def sample_input do
    """
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

  def has_three_vowels?(str) do
    str
    |> String.to_charlist()
    |> Enum.filter(fn char -> Enum.member?('aeiou', char) end)
    |> Enum.count()
    |> Kernel.>=(3)
  end

  def has_double_letters?(str) do
    str
    |> String.to_charlist()
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn a -> Enum.count(a) == 2 end)
    |> Enum.filter(fn [a, b] -> a == b end)
    |> Enum.count()
    |> Kernel.>(0)
  end

  def contains_disallowed_strings?(str) do
    disallowed = ['ab', 'cd', 'pq', 'xy']

    str
    |> String.to_charlist()
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn a -> Enum.member?(disallowed, a) end)
    |> Enum.count()
    |> Kernel.>(0)
  end

  def is_nice(str) do
    has_three_vowels?(str) && has_double_letters?(str) && !contains_disallowed_strings?(str)
  end

  def has_letter_sandwich?(str) do
    str
    |> String.to_charlist()
    |> Enum.chunk_every(3, 1)
    |> Enum.filter(fn a -> Enum.count(a) == 3 end)
    |> Enum.filter(fn [a, b, c] -> a == c end)
    |> Enum.count()
    |> Kernel.>(0)
  end

  def has_non_overlapping_repeats?(str) do
    str
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.chunk_every(2, 1)
    |> Enum.filter(fn a -> Enum.count(a) == 2 end)
    |> Enum.map(&Enum.unzip/1)
    |> Enum.map(fn {a, b} -> {a, MapSet.new(b)} end)
    |> Enum.reduce_while(
      %{},
      fn {term, positions}, acc ->
        case Map.get(acc, term) do
          nil ->
            {:cont, Map.put(acc, term, positions)}

          prev ->
            case MapSet.disjoint?(positions, prev) do
              true -> {:halt, :match}
              false -> {:cont, Map.put(acc, term, MapSet.union(positions, prev))}
            end
        end
      end
    )
    |> Kernel.==(:match)
  end

  def is_nice_redux(str) do
    has_letter_sandwich?(str) && has_non_overlapping_repeats?(str)
  end

  def solve(input) do
    input
    |> Enum.map(&is_nice/1)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def solve2(input) do
    input
    |> Enum.map(&is_nice_redux/1)
    |> Enum.filter(& &1)
    |> Enum.count()
  end
end

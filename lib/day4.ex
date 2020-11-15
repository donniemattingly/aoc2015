defmodule Day4 do
  @moduledoc false

  def real_input do
    Utils.get_input(4, 1)
  end

  def sample_input do
    """
    abcdef
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
  def solve2(input), do: solve(input)

  def parse_and_solve1(input),
      do: parse_input1(input)
          |> solve1
  def parse_and_solve2(input),
      do: parse_input2(input)
          |> solve2

  def parse_input(input) do
    input
    |> Utils.single_value()
  end

  def adventcoin_or_nil("000000" <> rest = hash, count) do
    {hash, count}
  end

  def adventcoin_or_nil(hash, count) do
    nil
  end

  def get_adventcoin_from_chunk(chunk) do
    chunk
    |> Enum.filter(&(&1))
    |> Enum.at(0)
  end

  def seed(input, count) do
    "#{input}#{count}"
  end

  def generate_adventcoin(input, count) do
    seed(input, count)
    |> Utils.md5()
    |> adventcoin_or_nil(count)
  end

  def run_chunk(chunk, input) do
    chunk
    |> Enum.map(&(Task.async(fn -> generate_adventcoin(input, &1) end)))
    |> Enum.map(&Task.await/1)
  end

  def solve(input) do
    1..10000000
    |> Stream.chunk_every(1000)
    |> Stream.map(&run_chunk(&1, input))
    |> Stream.map(&get_adventcoin_from_chunk/1)
    |> Stream.filter(&(&1))
    |> Stream.map(&IO.inspect/1)
    |> Stream.take(1)
    |> Enum.to_list()
    |> hd
  end
end

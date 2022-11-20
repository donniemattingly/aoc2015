defmodule Day3 do
  @moduledoc false

  def real_input do
    Utils.get_input(3, 1)
  end

  def sample_input do
    """
    ^v^v^v^v^v
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
    |> Utils.split_each_char()
  end

  def move("^", {x, y}), do: {x, y + 1}
  def move(">", {x, y}), do: {x + 1, y}
  def move("v", {x, y}), do: {x, y - 1}
  def move("<", {x, y}), do: {x - 1, y}

  def do_deliver_presents([move | moves], pos, visited) do
    new = move(move, pos)
    do_deliver_presents(moves, new, MapSet.put(visited, new))
  end

  def do_deliver_presents([], pos, visited) do
    visited
  end

  def deliver_presents(moves, pos) do
    do_deliver_presents(moves, pos, MapSet.new([pos]))
  end

  def solve(input) do
    deliver_presents(input, {0, 0})
    |> MapSet.size()
  end

  def do_santa_deliver_presents(
        [move | moves],
        santa_pos,
        robot_pos,
        santa_visited,
        robot_visited
      ) do
    new = move(move, santa_pos)

    do_robot_deliver_presents(
      moves,
      new,
      robot_pos,
      MapSet.put(santa_visited, new),
      robot_visited
    )
  end

  def do_santa_deliver_presents([], santa_pos, robot_pos, santa_visited, robot_visited) do
    MapSet.union(santa_visited, robot_visited)
  end

  def do_robot_deliver_presents(
        [move | moves],
        santa_pos,
        robot_pos,
        santa_visited,
        robot_visited
      ) do
    new = move(move, robot_pos)

    do_santa_deliver_presents(
      moves,
      santa_pos,
      new,
      santa_visited,
      MapSet.put(robot_visited, new)
    )
  end

  def do_robot_deliver_presents([], santa_pos, robot_pos, santa_visited, robot_visited) do
    MapSet.union(santa_visited, robot_visited)
  end

  def santa_and_robot_deliver_presents(moves, pos) do
    do_santa_deliver_presents(moves, pos, pos, MapSet.new([pos]), MapSet.new([pos]))
  end

  def solve2(input) do
    santa_and_robot_deliver_presents(input, {0, 0})
    |> MapSet.size()
  end
end

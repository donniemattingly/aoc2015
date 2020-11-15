defmodule Day2Test do
  use ExUnit.Case, async: true

  test "part 1: 2x3x4" do
    assert Day2.parse_and_solve1("2x3x4") == 58
  end

  test "part 1: 1x1x10" do
    assert Day2.parse_and_solve1("1x1x10") == 43
  end

  test "part1: real" do
    assert Day2.part1() == 1588178
  end

  test "part 2: 2x3x4" do
    assert Day2.parse_and_solve2("2x3x4") == 34
  end

  test "part 2: 1x1x10" do
    assert Day2.parse_and_solve2("1x1x10") == 14
  end

  test "part2: real" do
    assert Day2.part2() == 3783758
  end

end
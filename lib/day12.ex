defmodule Day12 do
  use Utils.DayBoilerplate, day: 12

  def sample_input do
    """
    {"a":2,"b":4}
    """
  end

  def parse_input(input) do
    input
    |> Jason.decode!()
  end

  def count_recursively(node) do
    cond do
      is_integer(node) -> node
      is_binary(node) -> 0
      is_list(node) -> node |> Enum.map(&count_recursively/1) |> Enum.sum()
      is_map(node) -> node |> Map.values() |> Enum.map(&count_recursively/1) |> Enum.sum()
      true -> 0
    end
  end

  def count_recursively2(node) do
    cond do
      is_integer(node) ->
        node

      is_binary(node) ->
        0

      is_list(node) ->
        node |> Enum.map(&count_recursively2/1) |> Enum.sum()

      is_map(node) ->
        if node |> Map.values() |> Enum.member?("red") do
          IO.puts("skipping")
          0
        else
          node |> Map.values() |> Enum.map(&count_recursively2/1) |> Enum.sum()
        end

      true ->
        0
    end
  end

  def solve(input) do
    count_recursively(input)
  end

  def solve2(input) do
    count_recursively2(input)
  end
end

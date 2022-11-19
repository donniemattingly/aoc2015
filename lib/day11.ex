defmodule Day11 do
  use Utils.DayBoilerplate, day: 11

  def sample_input do
    """
    """
  end

  def parse_input(input) do
    input
  end

  def solve(input) do
    input
  end

  def charlist_to_map(charlist) do
    charlist
    |> Enum.with_index()
    |> Enum.map(fn {a, b} -> {b, a} end)
    |> Map.new()
  end

  def map_to_charlist(map) do
    map
    |> Map.to_list()
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end

  def do_increment(password, 8), do: password

  def do_increment(password, index) do
    {carry, pw} =
      Map.get_and_update(password, index, fn
        122 -> {1, 97}
        curr -> {0, curr + 1}
      end)

    case carry do
      0 -> pw
      1 -> do_increment(pw, index + 1)
    end
  end

  def has_running_straight(password) do
    password
    |> Enum.chunk_every(3, 1)
    |> Enum.filter(fn l -> length(l) == 3 end)
    |> Enum.filter(fn [a, b, c] -> c - b == 1 and b - a === 1 end)
    |> length
    |> Kernel.>(0)
  end

  def has_confusing_characters(password) do
    chars = MapSet.new('oil')

    password
    |> MapSet.new()
    |> MapSet.intersection(chars)
    |> MapSet.size()
    |> Kernel.>(0)
  end

  def has_two_non_overlapping_pairs(password) do
    password
    |> Enum.chunk_by(& &1)
    |> Enum.filter(&(length(&1) == 2))
    |> length
    |> Kernel.>=(2)
  end

  def is_valid(password) do
    !has_confusing_characters(password) && has_running_straight(password) &&
      has_two_non_overlapping_pairs(password)
  end

  def increment(password) do
    password
    |> Enum.reverse()
    |> charlist_to_map
    |> do_increment(0)
    |> map_to_charlist
    |> Enum.reverse()
  end

  def next_valid_password(password) do
    next = increment(password)
    cond do
      is_valid(next) -> next
      true -> next_valid_password(next)
    end
  end
end

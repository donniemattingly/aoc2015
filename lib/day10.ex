defmodule Day10 do
  use Utils.DayBoilerplate, day: 10

  def sample_input do
    """
    """
  end

  def parse_input(input) do
    input
  end

  def solve(input) do
    '1113122113'
    |> do_look_and_say()
    |> length()
  end

  def convert_group_to_description(group) do
    char = hd group
    len = length(group)
    |> Integer.to_string()
    |> String.to_charlist()

    len ++ [char]
  end
  def do_look_and_say(input, 50), do: input
  def do_look_and_say(input, count \\ 0) do
    IO.inspect(count)
    input
    |> Enum.chunk_by(& &1)
    |> Enum.flat_map(&convert_group_to_description/1)
    |> do_look_and_say(count + 1)
  end

end
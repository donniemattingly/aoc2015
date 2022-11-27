defmodule Day19 do
  use Utils.DayBoilerplate, day: 19

  def sample_input do
    """
    H => HO
    H => OH
    O => HH

    HOH
    """
  end

  def parse_input(input) do
    [raw_replacements, molecule] = String.split(input, "\n\n")

    replacements =
      raw_replacements
      |> Utils.split_lines()
      |> Enum.map(&String.split(&1, " => "))
      |> Enum.map(fn [a, b] -> {a, b} end)

    {replacements, String.trim(molecule)}
  end

  def solve({replacements, molecule}) do
    replacements
    |> Enum.map(fn x ->  apply_replacement(molecule, x) end)
  end

  def apply_replacement(molecule, {a, b}) do
    IO.inspect({a, b})
    String.split(molecule, a)
  end
end

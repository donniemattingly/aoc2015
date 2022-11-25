defmodule Day16 do
  use Utils.DayBoilerplate, day: 16

  def sample_input do
    """
    Sue 1: goldfish: 6, trees: 9, akitas: 0
    Sue 2: goldfish: 7, trees: 1, akitas: 0
    Sue 3: cars: 10, akitas: 6, perfumes: 7
    Sue 4: perfumes: 2, vizslas: 0, cars: 6
    Sue 5: goldfish: 1, trees: 3, perfumes: 10
    Sue 6: children: 9, vizslas: 7, cars: 9
    Sue 7: cars: 6, vizslas: 5, cats: 3
    Sue 8: akitas: 10, vizslas: 9, children: 3
    Sue 9: vizslas: 8, cats: 2, trees: 1
    Sue 10: perfumes: 10, trees: 6, cars: 4
    Sue 11: cars: 9, children: 1, cats: 1
    Sue 12: pomeranians: 4, akitas: 6, goldfish: 8
    Sue 13: cats: 10, children: 5, trees: 9
    Sue 14: perfumes: 8, vizslas: 3, samoyeds: 1
    """
  end

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [[_, num]] = Regex.scan(~r/Sue (\d+): /, line)
    [_, l] = String.split(line, ~r/Sue \d+: /)
    {m, _} = Code.eval_string("[#{l}]")
    {num, MapSet.new(m)}
  end

  def mfcsam_output do
    [
      children: 3,
      cats: 7,
      samoyeds: 2,
      pomeranians: 3,
      akitas: 0,
      vizslas: 0,
      goldfish: 5,
      trees: 3,
      cars: 2,
      perfumes: 1
    ]
    |> MapSet.new()
  end

  def check_against_output(aunt) do
    kw = MapSet.to_list(aunt)
    output = mfcsam_output() |> MapSet.to_list()

    kw
    |> Enum.filter(fn {signal, value} ->
      output_val = Keyword.get(output, signal)
      case signal do
        :cats -> value > output_val
        :trees -> value > output_val
        :pomeranians -> value < output_val
        :goldfish -> value < output_val
        _ -> value == output_val
      end
    end)
    |> length()
    |> IO.inspect()
    |> Kernel.==(length(kw))
  end

  def solve(input) do
    input
    |> Enum.find(fn {num, set} -> MapSet.subset?(set, mfcsam_output()) end)
  end

  def solve2(input) do
    input
    |> Enum.find(fn {num, set} -> check_against_output(set) end)
  end
end

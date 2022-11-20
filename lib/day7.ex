defmodule Day7 do
  @moduledoc false

  use Bitwise
  use Memoize

  def real_input do
    Utils.get_input(7, 1)
  end

  def sample_input do
    """
    12 -> x
    1 OR x -> b
    b -> a
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
  def real_input2, do: Utils.get_input(7, 2)

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

  def parse_line(line) do
    [signal_term, output] = String.split(line, " -> ")
    signals = String.split(signal_term, " ")
    {parse_signal(signals), output}
  end

  def parse_signal([signal]) do
    case Regex.match?(~r/\d+/, signal) do
      true -> {:set, String.to_integer(signal)}
      false -> {:pass, signal}
    end
  end

  def parse_signal(["NOT", input]) do
    {:not, input}
  end

  def parse_signal([x, "AND", y]) do
    {:and, x, y}
  end

  def parse_signal([x, "OR", y]) do
    {:or, x, y}
  end

  def parse_signal([x, "LSHIFT", y]) do
    {:lshift, x, String.to_integer(y)}
  end

  def parse_signal([x, "RSHIFT", y]) do
    {:rshift, x, String.to_integer(y)}
  end

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(&parse_line/1)
  end

  def wires_from_instructions(instructions) do
    instructions
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(fn wire -> {wire, nil} end)
    |> Map.new()
  end

  def all_wires_have_signal?(wires) do
    wires
    |> Map.values()
    |> Enum.all?(fn wire -> wire != nil end)
  end

  def keys_from_input({:set, x}), do: []
  def keys_from_input({:pass, x}), do: [x]
  def keys_from_input({:not, x}), do: [x]
  def keys_from_input({command, x, y}) when is_number(y), do: [x]
  def keys_from_input({command, x, y}), do: [x, y]

  def can_perform_instruction?(wires, {input, output}) do
    res =
      input
      |> keys_from_input()
      |> Enum.map(&get_or_literal(wires, &1))
      |> Enum.all?(fn x -> x != nil end)

    res
  end

  def clamp(number),
    do:
      number
      |> min(65535)
      |> max(0)

  def shitty_not(number) do
    number
    |> Integer.to_string(2)
    |> String.pad_leading(16, "0")
    |> String.to_charlist()
    |> Enum.map(fn char ->
      case char do
        48 -> 49
        49 -> 48
      end
    end)
    |> to_string()
    |> String.to_integer(2)
  end

  def get_or_literal(wires, value) do
    case Regex.match?(~r/\d+/, value) do
      true -> String.to_integer(value)
      false -> Map.get(wires, value)
    end
  end

  def perform_instruction(wires, {{:set, number}, output}), do: Map.put(wires, output, number)

  def perform_instruction(wires, {{:pass, wire}, output}),
    do: Map.put(wires, output, get_or_literal(wires, wire))

  def perform_instruction(wires, {{:not, wire}, output}),
    do:
      Map.put(
        wires,
        output,
        get_or_literal(wires, wire)
        |> shitty_not
        |> clamp
      )

  def perform_instruction(wires, {{:lshift, wire, amount}, output}),
    do:
      Map.put(
        wires,
        output,
        get_or_literal(wires, wire)
        |> bsl(amount)
        |> clamp
      )

  def perform_instruction(wires, {{:rshift, wire, amount}, output}),
    do:
      Map.put(
        wires,
        output,
        get_or_literal(wires, wire)
        |> bsr(amount)
        |> clamp
      )

  def perform_instruction(wires, {{:and, x, y}, output}),
    do:
      Map.put(
        wires,
        output,
        band(get_or_literal(wires, x), get_or_literal(wires, y))
        |> clamp
      )

  def perform_instruction(wires, {{:or, x, y}, output}),
    do:
      Map.put(
        wires,
        output,
        bor(get_or_literal(wires, x), get_or_literal(wires, y))
        |> clamp
      )

  def execute_instructions(wires, instructions) do
    instructions
    |> Enum.reduce(
      {[], wires},
      fn instruction, {pending_instructions, new_wires} ->
        if can_perform_instruction?(new_wires, instruction) do
          {pending_instructions, perform_instruction(new_wires, instruction)}
        else
          {[instruction | pending_instructions], new_wires}
        end
      end
    )
  end

  def emulate_circuit(wires, instructions) do
    if all_wires_have_signal?(wires) do
      wires
    else
      {new_instructions, new_wires} = execute_instructions(wires, instructions)
      emulate_circuit(new_wires, new_instructions)
    end
  end

  def solve(input) do
    input
    |> wires_from_instructions
    |> emulate_circuit(input)
    |> Map.get("a")
  end

  def solve2(input) do
    input
    |> wires_from_instructions
    |> emulate_circuit(input)
    |> Map.get("a")
  end
end

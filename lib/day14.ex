defmodule Day14 do
  use Utils.DayBoilerplate, day: 14

  def sample_input do
    """
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    """
  end

  def parse_input(input) do
    input
    |> Utils.split_lines()
    |> Enum.map(fn line ->
      Regex.scan(~r/\d+/, line)
      |> Enum.map(fn [match] -> String.to_integer(match) end)
      |> List.to_tuple()
    end)
  end

  def reindeer_stream({speed, fly_time, rest_time}) do
    Stream.resource(
      fn -> {:flying, fly_time, 0} end,
      fn {status, time_left, dist} = _state ->
        case {status, time_left} do
          {:flying, 1} -> {[dist + speed], {:resting, rest_time, dist + speed}}
          {:resting, 1} -> {[dist], {:flying, fly_time, dist}}
          {:flying, _t} -> {[speed + dist], {:flying, time_left - 1, dist + speed}}
          {:resting, _t} -> {[dist], {:resting, time_left - 1, dist}}
        end
      end,
      fn _state -> nil end
    )
  end

  def solve(input) do
    input
    |> IO.inspect()
    |> Enum.map(&reindeer_stream/1)
    |> Stream.zip()
    |> Enum.at(2502)
    |> Tuple.to_list()
    |> Enum.max()
  end
end

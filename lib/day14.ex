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

  def make_reindeer_function({speed, fly_time, rest_time}) do
    fn {status, time_left, dist} ->
      case {status, time_left} do
        {:flying, 1} -> {:resting, rest_time, dist + speed}
        {:resting, 1} -> {:flying, fly_time, dist}
        {:flying, _t} -> {:flying, time_left - 1, dist + speed}
        {:resting, _t} -> {:resting, time_left - 1, dist}
      end
    end
  end

  def get_reindeer_func_and_initial_state({speed, fly_time, rest_time} = stats) do
    {
      make_reindeer_function(stats),
      {:flying, fly_time, 0},
      0
    }
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

  def tick(state) do
    updated = state |> Enum.map(fn {fun, state, score} -> {fun, fun.(state), score} end)
    {_, {_, _, lead}, _} = Enum.max_by(updated, fn {fun, {_, _, dist}, score} -> dist end)

    updated
    |> Enum.map(fn {fun, {_, _, dist} = state, score} ->
      cond do
        dist == lead -> {fun, state, score + 1}
        true -> {fun, state, score}
      end
    end)
  end

  def do_times(fun, state, 0), do: state

  def do_times(fun, state, count) do
    new_state = fun.(state)
    do_times(fun, new_state, count - 1)
  end

  def solve2(input) do
    state = input |> Enum.map(&get_reindeer_func_and_initial_state/1)
    do_times(&tick/1, state, 2503)
  end
end

defmodule Day04 do
  # https://adventofcode.com/2018/day/4
  def hello() do
    :hello
  end

  def parse_datetime(rec) do
    t = rec |> String.trim() |> String.split("]") |> List.first() |> String.trim("[")
    (t <> ":00+0000") |> DateTime.from_iso8601() |> elem(1)
  end

  def compare(rec1, rec2) do
    DateTime.compare(parse_datetime(rec1), parse_datetime(rec2)) == :lt
  end

  def get_id(record) do
    [[_, id]] = Regex.scan(~r{#(\d+)}, record)
    String.to_integer(id)
  end

  def get_minute(record) do
    [[_, min]] = Regex.scan(~r{:(\d\d)}, record)
    String.to_integer(min)
  end

  def calculate_sleep_time([], _current, result) do
    result
  end

  def calculate_sleep_time([head | tail], current, result) do
    # use cond/case here
    cond do
      String.contains?(head, "#") ->
        calculate_sleep_time(
          tail,
          {get_id(head), nil, nil},
          result
        )

      String.contains?(head, "falls asleep") ->
        calculate_sleep_time(tail, {elem(current, 0), get_minute(head), nil}, result)

      String.contains?(head, "wakes up") ->
        calculate_sleep_time(
          tail,
          {elem(current, 0), nil, nil},
          Map.merge(
            result,
            %{
              elem(current, 0) =>
                Map.new(elem(current, 1)..(get_minute(head) - 1), fn x -> {x, 1} end)
            },
            fn _k, v1, v2 ->
              Map.merge(v1, v2, fn _sk, sv1, sv2 ->
                sv1 + sv2
              end)
            end
          )
        )

      true ->
        IO.puts("ERROR")
        true
    end
  end

  def sleep_minutes(map) do
    map |> Map.values() |> Enum.sum()
  end

  def solve(records) do
    data = records |> sort_chronological |> calculate_sleep_time({}, Map.new())

    {topid, _} =
      data
      |> Map.to_list()
      |> Enum.map(fn {k, v} -> {k, sleep_minutes(v)} end)
      |> Enum.max_by(fn {_, v} -> v end)

    {top_minute, _} = Map.to_list(data[topid]) |> Enum.max_by(fn {_k, v} -> v end)
    topid * top_minute
  end

  def sort_chronological(records) do
    records |> Enum.sort(&compare/2)
  end

  def solve2(records) do
    data = records |> sort_chronological |> calculate_sleep_time({}, Map.new())

    r =
      data
      |> Map.to_list()
      |> Enum.map(fn {id, map} ->
        {id,
         Map.to_list(map)
         |> Enum.max_by(fn {_, count} ->
           count
         end)}
      end)
      |> Enum.max_by(fn {_, {_, count}} -> count end)

    {id, {minute, _}} = r
    id * minute
  end
end

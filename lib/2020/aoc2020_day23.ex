defmodule Aoc2020Day23 do
  import Enum

  def read_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> map(&String.to_integer/1)
  end

  def solve1(input) do
    cups =
      input
      |> read_input

    maxl = max(cups)
    minl = min(cups)

    # create a map of key: current cup => value: next cup
    [h | t] = cups
    values = t ++ [h]
    mcups = zip(cups, values) |> Map.new()

    r = move(mcups, minl, maxl, h, 0, 100)

    get_all_except_1(r, Map.get(r, 1), [])
    |> map(fn x -> Integer.to_string(x) end)
    |> join("")
  end

  def get_all_except_1(_, 1, result) do
    result
    |> reverse
  end

  def get_all_except_1(map, current, result) do
    get_all_except_1(map, Map.get(map, current), [current | result])
  end

  def solve2(input) do
    cups =
      input
      |> read_input

    cups = cups ++ to_list((max(cups) + 1)..1_000_000)
    [h | t] = cups
    values = t ++ [h]
    mcups = zip(cups, values) |> Map.new()

    maxl = max(cups)
    minl = min(cups)
    r = move(mcups, minl, maxl, h, 0, 10_000_000)
    a = Map.get(r, 1)
    b = Map.get(r, a)
    a * b
  end

  def move(cups, _minl, _maxl, _current, n, t) when n == t do
    cups
  end

  def move(cups, minl, maxl, current, n, t) do
    # identify 3 cups
    p1 = Map.get(cups, current)
    p2 = Map.get(cups, p1)
    p3 = Map.get(cups, p2)
    # and the one after p3, so we can link current to it
    p4 = Map.get(cups, p3)

    dest = get_dest(current - 1, [p1, p2, p3], minl, maxl)
    # "move" actually just update 4 links
    old_after_dest = Map.get(cups, dest)
    cups = Map.put(cups, dest, p1)
    cups = Map.put(cups, p3, old_after_dest)
    cups = Map.put(cups, current, p4)

    move(cups, minl, maxl, p4, n + 1, t)
  end

  def get_dest(dest, picked, min, max) when dest < min do
    get_dest(max, picked, min, max)
  end

  def get_dest(dest, picked, min, max) do
    if dest in picked do
      get_dest(dest - 1, picked, min, max)
    else
      dest
    end
  end
end

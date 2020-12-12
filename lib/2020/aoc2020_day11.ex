defmodule Aoc2020Day11 do
  import Enum

  def str_to_map(str) do
    str
    |> String.trim()
    |> String.split("\n", trim: true)
    |> with_index
    |> map(fn {cs, y} ->
      String.split(cs, "", trim: true) |> with_index |> map(fn {v, x} -> {{x, y}, v} end)
    end)
    |> concat
    |> Map.new()
  end

  def solve1(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    world = str_to_map(input)

    ymax = lines |> length

    [line | _rest] = lines
    xmax = String.length(line)

    # draw(world, xmax, ymax)
    change_til_stable(world, xmax, ymax, 4, &neighbors/4)
    |> count_occupied
  end

  def draw(world, xmax, ymax) do
    0..ymax
    |> map(fn y ->
      0..xmax
      |> map(fn x -> Map.get(world, {x, y}) || "X" end)
      |> join("")
      |> IO.inspect(label: y)
    end)
  end

  def count_occupied(seats) do
    seats |> Enum.filter(fn {{_x, _y}, v} -> v == "#" end) |> length
  end

  def change_til_stable(seats, xmax, ymax, min_occupied_to_empty, neighbors_func) do
    new =
      seats
      |> map(fn i -> next(seats, i, xmax, ymax, min_occupied_to_empty, neighbors_func) end)
      |> Map.new()

    # draw(new, xmax, ymax)

    if new == seats do
      new
    else
      change_til_stable(new, xmax, ymax, min_occupied_to_empty, neighbors_func)
    end
  end

  def next(_m, {{x, y}, "."}, _xmax, _ymax, _min_occupied_to_empty, _neighbors_func) do
    {{x, y}, "."}
  end

  def next(m, {{x, y}, "L"}, xmax, ymax, _min_occupied_to_empty, neighbors_func) do
    ns =
      neighbors_func.(m, {x, y}, xmax, ymax)
      |> map(fn i -> Map.get(m, i) end)
      |> filter(fn i -> i != nil end)

    if any?(ns, fn x -> x == "#" end) do
      {{x, y}, "L"}
    else
      {{x, y}, "#"}
    end
  end

  def next(m, {{x, y}, "#"}, xmax, ymax, min_occupied_to_empty, neighbors_func) do
    ns =
      neighbors_func.(m, {x, y}, xmax, ymax)
      |> map(fn i -> Map.get(m, i) end)
      |> filter(fn i -> i != nil end)

    occupied = ns |> filter(fn n -> n == "#" end) |> length

    if occupied >= min_occupied_to_empty do
      {{x, y}, "L"}
    else
      {{x, y}, "#"}
    end
  end

  def neighbors(_m, {x, y}, _, _) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
    |> filter(fn {x, y} -> x >= 0 && y >= 0 end)
  end

  def firstsee(m, xs) do
    find(xs, fn p -> Map.get(m, p) != nil && Map.get(m, p) != "." end)
  end

  def cansee(m, {x, y}, xmax, ymax) do
    [
      firstsee(m, (x - 1)..0 |> map(&{&1, y})),
      firstsee(m, (x + 1)..(xmax - 1) |> map(&{&1, y})),
      firstsee(m, (y - 1)..0 |> map(&{x, &1})),
      firstsee(m, (y + 1)..(ymax - 1) |> map(&{x, &1})),
      firstsee(m, diag1({x, y}, [], xmax, ymax)),
      firstsee(m, diag3({x, y}, [], xmax, ymax)),
      firstsee(m, diag2({x, y}, [], xmax, ymax)),
      firstsee(m, diag4({x, y}, [], xmax, ymax))
    ]
    |> uniq
    |> filter(&(&1 != nil))
    |> filter(fn {a, b} -> 0 <= a && a < xmax && 0 <= b && b < ymax end)
    |> filter(fn {x1, y1} -> {x1, y1} != {x, y} end)
  end

  @doc """
  Top part of \
  """
  def diag1({x, y}, acc, _xmax, _ymax) when x < 0 or y < 0 do
    acc |> reverse |> drop(1)
  end

  def diag1({x, y}, acc, xmax, ymax) do
    diag1({x - 1, y - 1}, [{x, y} | acc], xmax, ymax)
  end

  @doc """
  Bottom part of \
  """
  def diag3({x, y}, acc, xmax, ymax) when x >= xmax or y >= ymax do
    acc |> reverse |> drop(1)
  end

  def diag3({x, y}, acc, xmax, ymax) do
    diag3({x + 1, y + 1}, [{x, y} | acc], xmax, ymax)
  end

  @doc """
  Top part of /
  """
  def diag2({x, y}, acc, xmax, _ymax) when x >= xmax or y < 0 do
    acc |> reverse |> drop(1)
  end

  def diag2({x, y}, acc, xmax, ymax) do
    diag2({x + 1, y - 1}, [{x, y} | acc], xmax, ymax)
  end

  @doc """
  Bottom part of /
  """
  def diag4({x, y}, acc, _xmax, ymax) when x < 0 or y >= ymax do
    acc |> reverse |> drop(1)
  end

  def diag4({x, y}, acc, xmax, ymax) do
    diag4({x - 1, y + 1}, [{x, y} | acc], xmax, ymax)
  end

  def solve2(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    world = str_to_map(input)

    ymax = lines |> length

    [line | _rest] = lines
    xmax = String.length(line)

    # draw(world, xmax, ymax)
    change_til_stable(world, xmax, ymax, 5, &cansee/4)
    |> count_occupied
  end
end

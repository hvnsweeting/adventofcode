defmodule Aoc2020Day24 do
  import Enum

  @black 1
  @white 0
  @doc """
  Each point can be identified by treat e/w as +-2, ne/nw/se/sw as +-1
  nwwswee -> flips the reference tile itself {0, 0}
  """
  def coordinate(path) do
    path
    |> reduce({0, 0}, fn i, {x, y} ->
      case i do
        "nw" -> {x - 1, y - 1}
        "se" -> {x + 1, y + 1}
        "ne" -> {x + 1, y - 1}
        "sw" -> {x - 1, y + 1}
        "e" -> {x + 2, y}
        "w" -> {x - 2, y}
      end
    end)
  end

  def neighbors({x, y}) do
    [{x - 1, y - 1}, {x + 1, y + 1}, {x + 1, y - 1}, {x - 1, y + 1}, {x + 2, y}, {x - 2, y}]
  end

  def count_black_neighbors(world, tile) do
    neighbors(tile)
    |> map(fn k -> Map.get(world, k, 0) end)
    |> count(&is_black?(&1))
  end

  def is_black?(v) do
    rem(v, 2) == @black
  end

  def next(world, tile) do
    v = Map.get(world, tile)

    case is_black?(v) do
      true ->
        c = count_black_neighbors(world, tile)

        cond do
          c == 0 -> @white
          c > 2 -> @white
          true -> @black
        end

      false ->
        c = count_black_neighbors(world, tile)

        case c do
          2 -> @black
          _ -> @white
        end
    end
  end

  defp parse_line(s) do
    parse_line(s, [])
  end

  def parse_line("se" <> t, result) do
    parse_line(t, ["se" | result])
  end

  def parse_line("sw" <> t, result) do
    parse_line(t, ["sw" | result])
  end

  def parse_line("nw" <> t, result) do
    parse_line(t, ["nw" | result])
  end

  def parse_line("ne" <> t, result) do
    parse_line(t, ["ne" | result])
  end

  def parse_line("e" <> t, result) do
    parse_line(t, ["e" | result])
  end

  def parse_line("w" <> t, result) do
    parse_line(t, ["w" | result])
  end

  def parse_line("", result) do
    result
    |> reverse
  end

  @doc """
  Read steps and turns to a dict of point -> number of visit
  An odd visited points would be flipped odd times -> black
  Otherwise it is white
  """
  def read_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> map(&parse_line/1)
    |> map(fn p -> coordinate(p) end)
    |> frequencies
  end

  def solve1(input) do
    input
    |> read_input
    |> Map.values()
    |> count(fn v -> v == @black end)
  end

  def solve2(input) do
    world =
      input
      |> read_input

    1..100
    |> reduce(world, fn _i, acc ->
      added_neighbors =
        acc
        |> Map.keys()
        |> map(fn k -> neighbors(k) end)
        |> concat
        |> uniq
        |> reduce(acc, fn k, acc -> Map.update(acc, k, 0, fn old -> old end) end)

      added_neighbors
      |> map(fn {k, _v} ->
        {k, next(added_neighbors, k)}
      end)
      |> Map.new()
    end)
    |> count(fn {_k, v} -> is_black?(v) end)
  end
end

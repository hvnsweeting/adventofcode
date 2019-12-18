defmodule Aoc2019Day17 do
  def solve1(input) do
    input |> String.split(",") |> length
    # |> IO.puts
    input
    |> Intcode.check_raw_output([])
    |> List.to_string()
    |> find_intersects
    |> sum_of_aligment_params
  end

  def find_intersects(view) do
    scaffolds =
      view
      |> String.split()
      |> Enum.map(fn line ->
        line
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.filter(fn {code, _} -> code == ?# end)
        |> Enum.map(fn {_, x} -> x end)
      end)
      |> Enum.with_index()
      |> Enum.map(fn {xs, idx} -> for x <- xs, do: {x, idx} end)
      |> Enum.concat()
      |> MapSet.new()

    scaffolds
    |> Enum.filter(fn {x, y} ->
      MapSet.member?(scaffolds, {x - 1, y}) && MapSet.member?(scaffolds, {x + 1, y}) &&
        MapSet.member?(scaffolds, {x, y - 1}) && MapSet.member?(scaffolds, {x, y + 1})
    end)
  end

  def sum_of_aligment_params(intersects) do
    intersects |> Enum.map(fn {x, y} -> x * y end) |> Enum.sum()
  end
end

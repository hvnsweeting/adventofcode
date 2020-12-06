defmodule Aoc2020Day06 do
  import Enum

  def solve1(input) do
    input
    |> String.split("\n\n")
    |> map(fn s -> String.replace(s, "\n", "") end)
    |> map(fn x -> String.to_charlist(x) end)
    |> map(fn x -> MapSet.new(x) end)
    |> map(fn s -> MapSet.size(s) end)
    |> sum
  end

  def solve2(input) do
    input
    |> String.split("\n\n")
    |> map(fn s -> String.split(s) end)
    |> map(fn xs ->
      map(xs, fn x -> MapSet.new(String.to_charlist(x)) end)
    end)
    |> map(fn ms ->
      reduce(ms, fn x, acc ->
        MapSet.intersection(x, acc)
      end)
    end)
    |> map(fn s -> MapSet.size(s) end)
    |> sum
  end
end

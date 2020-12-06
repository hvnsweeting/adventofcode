defmodule Aoc2020Day06 do
  import Enum

  def solve1(input) do
    input
    |> String.split("\n\n")
    |> map(&String.replace(&1, "\n", ""))
    |> map(&String.to_charlist(&1))
    |> map(&MapSet.new(&1))
    |> map(&MapSet.size(&1))
    |> sum
  end

  def solve2(input) do
    input
    |> String.split("\n\n")
    |> map(&String.split(&1))
    |> map(fn xs ->
      map(xs, fn x -> x |> String.to_charlist() |> MapSet.new() end)
    end)
    |> map(fn ms ->
      reduce(ms, fn x, acc ->
        MapSet.intersection(x, acc)
      end)
    end)
    |> map(&MapSet.size(&1))
    |> sum
  end
end

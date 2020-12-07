defmodule Aoc2020Day07 do
  import Enum

  def solve1(input) do
    rules = input
            |> String.replace(" bag.", " bags.")
            |> String.replace(" bag,", " bags,")
    |> String.trim()
    |> String.split("\n")
    |> map(&(String.trim(&1, ".")))
    |> map(fn x -> x |> String.split("contain") end)
    |> map(fn [h|t] ->
      IO.inspect(h)
      {h|>String.trim, parse_inside(t)}
    end)



    rm = Map.new(rules)

    ks = rm |> Map.keys
    ks |> Enum.filter(fn k -> contain(rm, k, "shiny gold bag") end)
    |> IO.inspect
    |> length


  end

  def parse_inside([h|_]) do
    h
    |> String.trim
    |> String.split(",", trim: true)
    |> map(fn x -> x |> String.trim end)
    |> filter(fn x -> x != "no other bags" end)
    |> map(fn x ->
      [h,t|r] = String.split(x, " ", parts: 2)
      t
    end
      )


  end

  def contain(rules, key, bag) do
    ks = Map.get(rules, key)
    if ks == nil do
      IO.inspect({"notfound", key})
      false
    else
      Enum.any?(ks, fn s -> String.contains?(s, bag) end) || Enum.any?(ks, fn k -> contain(rules, k, bag) end)
    end
  end
end

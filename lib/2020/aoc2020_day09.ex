defmodule Aoc2020Day09 do
  import Enum

  def solve1(input, preamble \\ 25) do
    ns =
      input
      |> String.trim()
      |> String.split("\n")
      |> map(&String.to_integer(&1))

    p = take(ns, preamble)
    rem = drop(ns, preamble)

    solve(rem, p)
  end

  def solve([], _p) do
    raise "failed"
  end

  def solve([h | t], ps = [_ | tp]) do
    options = for i <- ps, j <- ps, (fn x, y -> x != y end).(i, j), do: i + j

    if h in options do
      solve(t, tp ++ [h])
    else
      h
    end
  end

  def solve2(input) do
    ns =
      input
      |> String.trim()
      |> String.split("\n")
      |> map(&String.to_integer(&1))

    r =
      0..length(ns)
      |> map(fn i -> drop(ns, i) end)
      |> find_value(fn x -> s2(x, 0, []) end)

    min(r) + max(r)
  end

  def s2([], _acc, vs) do
    vs
  end

  def s2([h | t], acc, vs) do
    cond do
      h + acc == 15_690_279 -> [h | vs]
      h + acc > 15_690_279 -> false
      h + acc < 15_690_279 -> s2(t, acc + h, [h | vs])
    end
  end
end

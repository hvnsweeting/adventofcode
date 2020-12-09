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

    find_invalid_number(rem, p)
  end

  def find_invalid_number([], _p) do
    raise "failed"
  end

  def find_invalid_number([h | t], ps = [_ | tp]) do
    options = for i <- ps, j <- ps, (fn x, y -> x != y end).(i, j), do: i + j

    if h in options do
      find_invalid_number(t, tp ++ [h])
    else
      h
    end
  end

  def solve2(input) do
    target = solve1(input)

    ns =
      input
      |> String.trim()
      |> String.split("\n")
      |> map(&String.to_integer(&1))

    r =
      0..length(ns)
      |> Stream.map(fn i -> drop(ns, i) end)
      |> find_value(fn xs -> find_contiguous_range(xs, 0, [], target) end)

    min(r) + max(r)
  end

  def find_contiguous_range([], acc, vs, target) when acc == target do
    vs
  end

  def find_contiguous_range([], _acc, _vs, _target) do
    false
  end

  def find_contiguous_range([h | t], acc, vs, target) do
    cond do
      h + acc == target -> [h | vs]
      h + acc > target -> false
      h + acc < target -> find_contiguous_range(t, acc + h, [h | vs], target)
    end
  end
end

defmodule Aoc2020Day15 do
  import Enum

  def solve2(input) do
    xs =
      input
      |> String.trim()
      |> String.split(",", trim: true)
      |> map(&String.to_integer/1)

    m =
      xs
      |> with_index
      |> map(fn {v, i} -> {v, [i + 1]} end)
      |> Map.new()

    solve(length(xs) + 1, List.last(xs), true, m)
  end

  def solve(30_000_001, last, _is_first, _m) do
    last
  end

  def solve(turn, last, is_first, m) do
    n =
      if is_first do
        0
      else
        # if spoken
        [a, b | _] = Map.get(m, last)
        a - b
      end

    v = Map.get(m, n)

    {is_first, m} =
      if v == nil do
        {true, Map.put(m, n, [turn])}
      else
        {false, Map.update!(m, n, fn [h | _] -> [turn, h] end)}
      end

    # IO.inspect({turn, "in", last, "out", n, m})

    solve(turn + 1, n, is_first, m)
  end
end

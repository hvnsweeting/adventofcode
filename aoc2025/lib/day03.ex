defmodule Aoc2025.Day03 do
  @doc "
  Bruteforce pick all 2 possible digits
  "
  def find_largest_joltage(line) do
    digits =
      line
      |> Integer.digits()
      |> Enum.with_index()

    choices =
      for {i, idx} <- digits do
        Enum.max(
          for {j, jdx} <- digits, jdx > idx do
            i * 10 + j
          end,
          &>=/2,
          fn -> 0 end
        )
      end

    choices
    |> Enum.max()
  end

  def solve(input, find_largest \\ &find_largest_joltage/1) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x -> x |> Integer.parse() |> elem(0) end)
    # |> Enum.map(fn x -> find_largest_joltage_v2(x, 2) end)
    # |> IO.inspect(":X")
    |> Enum.map(find_largest)
    |> Enum.sum()
  end

  def solve1(input) do
    solve(input)
  end

  @doc "
  Find the largest digit from left to right, pick first one
  continue with next largest digit after it
  ...
  The first digit will only pick from all digits except the last n-1 digits, e.g the number has 3 digits and we need to pick 3,
   the first one can only pick from 1st digit, it must leave 2 remains digits for 2 remain digits.
  "
  def find_largest_joltage_v2(battery_bank, n \\ 12) do
    rev =
      battery_bank
      |> Integer.digits()
      |> Enum.with_index()
      |> Enum.reverse()

    {a, ia} =
      rev
      |> Enum.drop(n - 1)
      |> Enum.reverse()
      |> Enum.max_by(fn {x, _idx1} -> x end)

    {ds, _} =
      Enum.reduce(2..n, {[a], ia}, fn i, {ns, idx} ->
        {v, iv} =
          rev
          |> Enum.drop(n - i)
          |> Enum.reverse()
          |> Enum.drop(idx + 1)
          |> Enum.max_by(fn {x, _} -> x end)

        # |> IO.inspect()

        {[v | ns], iv}
      end)

    ds |> Enum.reverse() |> Integer.undigits()
  end

  def solve2(input) do
    solve(input, &find_largest_joltage_v2/1)
  end
end

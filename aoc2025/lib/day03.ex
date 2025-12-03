defmodule Aoc2025.Day03 do
  def find_largest_joltage(line) do
    digits =
      line
      |> String.graphemes()
      |> Enum.with_index()

    choices =
      for {i, idx} <- digits do
        Enum.max(
          for {j, jdx} <- digits, jdx > idx do
            {ni, ""} = Integer.parse(i)
            {nj, ""} = Integer.parse(j)
            ni * 10 + nj
          end,
          &>=/2,
          fn -> 0 end
        )
      end

    choices
    |> Enum.max()
  end

  def solve(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&find_largest_joltage/1)
    # |> IO.inspect(":X")
    |> Enum.sum()
  end

  def find_largest_joltage_v2(battery_bank, n \\ 12) do
    digits =
      battery_bank
      |> String.graphemes()
      |> Enum.with_index()

    rev = Enum.reverse(digits)

    {a, ia} =
      rev
      |> Enum.drop(n - 1)
      |> Enum.reverse()
      |> Enum.max_by(fn {x, _idx1} -> x end)

    # |> IO.inspect(label: "first")

    {ds, _} =
      Enum.reduce(2..12, {[a], ia}, fn i, {ns, idx} ->
        {v, iv} =
          rev
          |> Enum.drop(n - i)
          |> Enum.reverse()
          |> Enum.drop(idx + 1)
          |> Enum.max_by(fn {x, _} -> x end)

        # |> IO.inspect()

        {[v | ns], iv}
      end)

    ds |> Enum.reverse() |> Enum.join() |> Integer.parse() |> elem(0)
  end

  def solve2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&find_largest_joltage_v2/1)
    |> Enum.sum()
  end
end

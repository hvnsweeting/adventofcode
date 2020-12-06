defmodule Aoc2020Day05 do
  import Enum

  def solve1(input) do
    # IO.puts(input)

    input
    |> String.split("\n", trim: true)
    |> Enum.map(&row_column/1)
    |> Enum.map(fn {r, c} -> r * 8 + c end)
    |> max
  end

  def row_to_num([], lo, _hi, ?F) do
    lo
  end

  def row_to_num([], _lo, hi, ?B) do
    hi
  end

  def row_to_num([?F | t], lo, hi, _last) do
    row_to_num(t, lo, trunc(hi - (hi - lo) / 2), ?F)
  end

  def row_to_num([?B | t], lo, hi, _last) do
    row_to_num(t, round((hi - lo) / 2) + lo, hi, ?B)
  end

  def row_column(line) do
    chars =
      line
      |> String.to_charlist()

    row = chars |> take(7)
    column = chars |> drop(7)

    column =
      Enum.map(column, fn
        ?L -> ?F
        ?R -> ?B
      end)

    {row_to_num(row, 0, 127, 0), row_to_num(column, 0, 7, 0)}
  end

  def solve2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&row_column/1)
    |> group_by(fn {r, _} -> r end)
    |> sort
    |> filter(fn {_, rc} -> length(rc) != 8 end)
    |> map(fn {_, rc} -> sort(rc) end)
    |> Enum.each(&IO.inspect/1)

    # this output
    # [{6, 7}]
    # [{64, 0}, {64, 1}, {64, 2}, {64, 3}, {64, 4}, {64, 5}, {64, 6}]
    # [{113, 0}, {113, 1}, {113, 2}]
    # the missing is 64, 7
    64 * 8 + 7
  end
end

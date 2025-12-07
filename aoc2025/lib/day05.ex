defmodule Aoc2025.Day05 do
  @doc "
  "
  def parse(input) do
    [fresh_id_ranges, available_ids] =
      input
      |> String.trim()
      |> String.split("\n\n")

    ranges =
      fresh_id_ranges
      |> String.split("\n")
      |> Enum.map(fn range ->
        [start, end_] =
          String.split(range, "-")
          |> Enum.map(fn n ->
            {i, ""} = Integer.parse(n)
            i
          end)

        start..end_//1
      end)

    {ranges,
     available_ids |> String.split("\n") |> Enum.map(fn i -> Integer.parse(i) |> elem(0) end)}
  end

  def fresh?(ranges, id) do
    Enum.any?(ranges, fn range -> id in range end)
  end

  def solve(input) do
    {ranges, avail_ids} = parse(input)

    avail_ids
    |> Enum.filter(fn id -> fresh?(ranges, id) end)
    |> Enum.count()
  end

  def count_fresh([], _, res) do
    res
    |> Enum.sum()
  end

  def count_fresh([h | t], cursor, res) do
    # IO.inspect({h, cursor, res})
    if cursor < h.first do
      count_fresh(t, h.last, [h.last - h.first + 1 | res])
    else
      # h.fist ... h.last ... cursor
      if cursor > h.last do
        count_fresh(t, cursor, [0 | res])
      else
        count_fresh(t, h.last, [h.last - cursor | res])
      end
    end
  end

  def solve2(input) do
    {ranges, _avail_ids} = parse(input)
    count_fresh(ranges |> Enum.sort() |> Enum.filter(fn r -> r.first <= r.last end), 0, [])
  end
end

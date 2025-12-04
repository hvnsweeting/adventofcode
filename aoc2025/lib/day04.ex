defmodule Aoc2025.Day04 do
  @doc "
  "
  def to_map(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {cells, row} ->
      cells
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {c, col} -> {{col, row}, c} end)
    end)
    |> Enum.concat()
    |> Enum.into(%{})
  end

  @roll_of_paper "@"
  def adjacent_rolls(m, {{x, y}, _}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.map(fn coor -> {coor, Map.get(m, coor)} end)
    |> Enum.filter(fn {_, c} -> c == @roll_of_paper end)
  end

  def solve(input) do
    m =
      input
      |> to_map

    m
    |> Enum.to_list()
    |> Enum.filter(fn {_, c} -> c == @roll_of_paper end)
    |> Enum.map(fn i -> adjacent_rolls(m, i) end)
    |> Enum.filter(fn adjs -> Enum.count(adjs) < 4 end)
    |> Enum.count()
  end

  def solve2(input) do
    m =
      input
      |> to_map

    rolls =
      m
      |> Enum.to_list()
      |> Enum.filter(fn {_, c} -> c == @roll_of_paper end)

    forklift_remove(m, rolls, [])
    |> Enum.count()
  end

  def forklift_remove(m, rolls, total_removed) do
    {removed, remain} =
      rolls
      |> Enum.split_with(fn i -> adjacent_rolls(m, i) |> Enum.count() < 4 end)

    if removed == [] do
      total_removed
    else
      forklift_remove(
        for i <- m, i not in removed, into: %{} do
          i
        end,
        remain,
        total_removed ++ removed
      )
    end
  end
end

defmodule Aoc2020Day01 do
  def solve1(input) do
    numbers =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> MapSet.new()

    v =
      numbers
      |> Enum.find(fn x -> MapSet.member?(numbers, 2020 - x) end)

    v * (2020 - v)
  end

  def solve2(input) do
    numbers =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> MapSet.new()

    rems =
      numbers
      |> Enum.map(fn x -> 2020 - x end)

    m =
      numbers
      |> Enum.map(fn x -> {2020 - x, x} end)
      |> Map.new()

    rems
    |> Enum.find_value(fn r ->
      n =
        Enum.find(numbers, fn n ->
          MapSet.member?(numbers, r - n) && r + m[r] == 2020
        end)

      if n, do: n * m[r] * (r - n)
    end)
  end
end

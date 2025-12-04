defmodule Aoc2025.Day01 do
  def rotate(current, rotation) do
    if String.starts_with?(rotation, "R") do
      sum = current + (rotation |> String.trim("R") |> Integer.parse() |> elem(0))
      rem(sum, 100)
    else
      new = current - (rotation |> String.trim("L") |> Integer.parse() |> elem(0))

      if new < 0 do
        100 - rem(abs(new), 100)
      else
        new
      end
    end
  end

  def solve1(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.scan(50, fn rotation, acc -> rotate(acc, rotation) end)
    |> Enum.filter(fn x -> x == 0 end)
    |> Enum.count()
  end

  def rotatev2({current, count}, rotation) do
    # IO.inspect({{current, count}, rotation})
    if String.starts_with?(rotation, "R") do
      sum = current + (rotation |> String.trim("R") |> Integer.parse() |> elem(0))
      {rem(sum, 100), count + div(sum, 100)}
    else
      new = current - (rotation |> String.trim("L") |> Integer.parse() |> elem(0))

      {if new < 0 do
         rem(100 - rem(abs(new), 100), 100)
       else
         new
       end,
       count +
         cond do
           new < 0 and current != 0 -> div(abs(new), 100) + 1
           new < 0 and current == 0 -> div(abs(new), 100)
           new == 0 -> 1
           true -> 0
         end}
    end
  end

  def solve2(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.scan({50, 0}, fn rotation, acc -> rotatev2(acc, rotation) end)
    |> Enum.reverse()
    |> hd
    |> elem(1)
  end
end

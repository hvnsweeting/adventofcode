defmodule Aoc2019Day8 do
  def solve_1() do
    {:ok, text} = File.read("test/input2019_08_1.txt")

    min_zero =
      text
      |> String.trim()
      |> String.to_charlist()
      |> Enum.chunk_every(25 * 6)
      |> Enum.min_by(fn l -> Enum.count(l, fn c -> c == ?0 end) end)

    Enum.count(min_zero, fn x -> x == ?1 end) * Enum.count(min_zero, fn x -> x == ?2 end)
  end

  def get_final_pixel([]) do
    ' '
  end

  def get_final_pixel([h | t]) do
    if h == ?1 do
      1
    else
      if h == ?0 do
        0
      else
        get_final_pixel(t)
      end
    end
  end

  def solve_2() do
    {:ok, text} = File.read("test/input2019_08_1.txt")

    text
    |> String.trim()
    |> String.to_charlist()
    |> Enum.chunk_every(25 * 6)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&get_final_pixel/1)
    |> Enum.chunk_every(25)
    |> IO.inspect()
  end
end

defmodule Aoc2019Day5 do
  import Intcode

  def solve_part_1(text) do
    text |> check_output([1])
  end

  def solve_part_2(text) do
    text |> check_output([5])
  end
end

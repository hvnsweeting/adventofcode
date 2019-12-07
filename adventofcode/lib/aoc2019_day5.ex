defmodule Aoc2019Day5 do
  import Intcode
  def solve_part_1() do
    {:ok, text} = File.read("test/input2019_05_1.txt")
                  #|> elem(1)
    text |> run

  end
end

IO.inspect(Aoc2019Day5.solve_part_1())

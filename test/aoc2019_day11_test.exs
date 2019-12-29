defmodule Aoc2019Day11Test do
  use ExUnit.Case

  test "solve1" do
    {:ok, input} = File.read("test/input2019_11.txt")
    assert Aoc2019Day11.solve1(input) == 2418
  end

  test "solve2" do
    {:ok, input} = File.read("test/input2019_11.txt")

    assert Aoc2019Day11.solve2(input) ==
             ". . # # . . # # # . . # # # # . . . # # . . # # . . # . . . . # # # . . # # # . . . .
. # . . # . # . . # . # . . . . . . . # . # . . # . # . . . . # . . # . # . . # . . .
. # . . . . # . . # . # # # . . . . . # . # . . # . # . . . . # . . # . # . . # . . .
. # . # # . # # # . . # . . . . . . . # . # # # # . # . . . . # # # . . # # # . . . .
. # . . # . # . # . . # . . . . # . . # . # . . # . # . . . . # . . . . # . # . . . .
. . # # # . # . . # . # # # # . . # # . . # . . # . # # # # . # . . . . # . . # . . ."
  end
end

defmodule Aoc2020Day17Test do
  use ExUnit.Case

  test "1" do
    input = "
.#.
..#
###"
    assert Aoc2020Day17.solve1(input) == 112
    {:ok, input} = File.read("test/input2020_17")
    assert Aoc2020Day17.solve1(input) == 382
  end


  test "2" do
    input = "
.#.
..#
###"
    assert Aoc2020Day17.solve2(input) == 848
    {:ok, input} = File.read("test/input2020_17")
    assert Aoc2020Day17.solve2(input) == 2552
  end
end

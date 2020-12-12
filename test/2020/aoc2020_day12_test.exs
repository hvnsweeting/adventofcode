defmodule Aoc2020Day12Test do
  use ExUnit.Case
  @sample "
  F10
N3
F7
R90
F11
  "

  test "2" do
    # assert Aoc2020Day12.solve1(@sample) == 25
    {:ok, input} = File.read("test/input2020_12")
    assert Aoc2020Day12.solve2(input) == 42495
  end
end

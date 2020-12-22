defmodule Aoc2020Day22Test do
  use ExUnit.Case
  @input "
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
    "

  test "1" do
    assert Aoc2020Day22.solve1(@input) == 306
    {:ok, input} = File.read("test/input2020_22")
    assert Aoc2020Day22.solve1(input) == 32102
  end

  test "2" do
    assert Aoc2020Day22.solve2(@input) == 291
    {:ok, input} = File.read("test/input2020_22")
    assert Aoc2020Day22.solve2(input) == 34173
  end
end

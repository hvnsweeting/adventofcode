defmodule Aoc2020Day11Test do
  use ExUnit.Case
  @sample "L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL"

  test "test 1" do
    assert Aoc2020Day11.solve1(@sample) == 37

    {:ok, input} = File.read("test/input2020_11")
    assert Aoc2020Day11.solve1(input) == 2222
  end

  test "test 2" do
    assert Aoc2020Day11.solve2(@sample) == 26
    {:ok, input} = File.read("test/input2020_11")
    assert Aoc2020Day11.solve2(input) == 2032
  end
end

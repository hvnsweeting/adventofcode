defmodule Aoc2020Day14Test do
  use ExUnit.Case

  test "1" do
    input = "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
   mem[8] = 11
   mem[7] = 101
   mem[8] = 0"
    assert Aoc2020Day14.solve1(input) == 165
    {:ok, input} = File.read("test/input2020_14")
    assert Aoc2020Day14.solve1(input) == 8_471_403_462_063
  end

  test "2" do
    input = "
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1"
    assert Aoc2020Day14.solve2(input) == 208
    {:ok, input} = File.read("test/input2020_14")
    assert Aoc2020Day14.solve2(input) == 2_667_858_637_669
  end
end

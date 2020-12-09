defmodule Aoc2020Day09Test do
  use ExUnit.Case

  test "p1" do
    input = "
    35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
    "
    assert Aoc2020Day09.solve1(input, 5) == 127
    {:ok, input} = File.read("test/input2020_9")
    assert Aoc2020Day09.solve1(input) == 15_690_279
  end

  test "p2" do
    {:ok, input} = File.read("test/input2020_9")
    assert Aoc2020Day09.solve2(input) == 2_174_232
  end
end

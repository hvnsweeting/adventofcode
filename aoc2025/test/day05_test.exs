defmodule Aoc2025.Day05.Test do
  use ExUnit.Case

  @example "3-5
10-14
16-20
12-18

1
5
8
11
17
32"
  test "solve" do
    assert Aoc2025.Day05.solve(@example) == 3
    {:ok, text} = File.read("test/input05")
    assert Aoc2025.Day05.solve(text) == 770
  end

  test "solve2" do
    assert Aoc2025.Day05.solve2(@example) == 14
    {:ok, text} = File.read("test/input05")
    assert Aoc2025.Day05.solve2(text) == 357_674_099_117_260
  end
end

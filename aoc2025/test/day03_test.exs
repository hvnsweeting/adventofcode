defmodule Aoc2025Day03Test do
  use ExUnit.Case

  @input "987654321111111
811111111111119
234234234234278
818181911112111"

  test "solve" do
    assert Aoc2025.Day03.solve(@input) == 357
    {:ok, text} = File.read("test/input03")
    assert Aoc2025.Day03.solve(text) == 16812

    assert Aoc2025.Day03.solve(text, fn x -> Aoc2025.Day03.find_largest_joltage_v2(x, 2) end) ==
             16812
  end

  test "solve2" do
    assert Aoc2025.Day03.solve2(@input) == 3_121_910_778_619
    {:ok, text} = File.read("test/input03")
    assert Aoc2025.Day03.solve2(text) == 166_345_822_896_410
  end
end

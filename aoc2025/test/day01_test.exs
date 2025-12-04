defmodule Aoc2025Day01Test do
  use ExUnit.Case

  @example "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"

  test "solve" do
    assert Aoc2025.Day01.solve1(@example) == 3
    # {:ok, text} = File.read("test/input01")
    # assert Aoc2025.Day01.solve1(text) == 1168
  end

  test "solve2" do
    assert Aoc2025.Day01.solve2(@example) == 6
    {:ok, text} = File.read("test/input01")
    assert Aoc2025.Day01.solve2(text) == 7199
  end
end

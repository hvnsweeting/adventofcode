defmodule Aoc2025Day10Test do
  use ExUnit.Case

  @example "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"

  test "solve" do
    assert Aoc2025.Day10.solve1(@example) == 7
    assert Aoc2025.Day10.button_to_bits("...#." |> String.graphemes, [0,2,3,4]) == 23
    {:ok, text} = File.read("test/input10")
    # assert Aoc2025.Day10.solve1(text) == 1168
  end

  test "solve2" do
    # assert Aoc2025.Day10.solve2(@example) == 6
    # {:ok, text} = File.read("test/input10")
    # assert Aoc2025.Day10.solve2(text) == 7199
  end
end

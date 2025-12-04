defmodule Aoc2025Day04Test do
  use ExUnit.Case

  @example "
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@."

  test "solve" do
    assert Aoc2025.Day04.solve(@example) == 13
    # {:ok, text} = File.read("test/input04")
    # assert Aoc2025.Day04.solve(text) == 1467
  end

  test "solve2" do
    assert Aoc2025.Day04.solve2(@example) == 43
    # {:ok, text} = File.read("test/input04")
    # assert Aoc2025.Day04.solve2(text) == 8484
  end
end

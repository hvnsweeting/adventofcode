defmodule Aoc2020Day18Test do
  use ExUnit.Case

  @tag timeout: :infinity
  @tag slow: true
  test "1" do
    input = "
(1 + (2 * 3) + (4 * (5 + 6)))
    "
    assert Aoc2020Day18.solve1(input) == 51

    # takes ~ 140s to run
    {:ok, input} = File.read("test/input2020_18")
    assert Aoc2020Day18.solve1(input) == 4_491_283_311_856
  end

  @tag timeout: :infinity
  @tag slow: true
  test "2" do
    input = "2 * 3 + (4 * 5)"
    assert Aoc2020Day18.solve2(input) == 46

    # take ~ 47s to run
    {:ok, input} = File.read("test/input2020_18")
    assert Aoc2020Day18.solve2(input) == 68_852_578_641_904
  end
end

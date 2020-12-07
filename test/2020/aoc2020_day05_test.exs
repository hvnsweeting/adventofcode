defmodule Aoc2020Day05Test do
  use ExUnit.Case

  test "p1" do
    {:ok, input} = File.read("test/input2020_5")
    # input = "FBFBBFFRLR"
    assert Aoc2020Day05.solve1(input) == 906
  end

  test "p2" do
    {:ok, input} = File.read("test/input2020_5")
    assert Aoc2020Day05.solve2(input) == 519
  end
end

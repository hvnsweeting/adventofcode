defmodule Aoc2020Day01Test do
  use ExUnit.Case

  test "solve1" do
    {:ok, input} = File.read("test/aoc2020_day01.txt")
    #    #input = "1721
    # 979
    # 366
    # 299
    # 675
    # 1456"
    assert Aoc2020Day01.solve1(input) == 1_006_875
  end

  test "solve2" do
    {:ok, input} = File.read("test/aoc2020_day01.txt")
    assert Aoc2020Day01.solve2(input) == 165_026_160
  end
end

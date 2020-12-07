defmodule Aoc2020Day01Test do
  use ExUnit.Case

  test "solve1" do
    {:ok, input} = File.read("test/input2020_1")
    #    #input = "1721
    # 979
    # 366
    # 299
    # 675
    # 1456"
    assert Aoc2020Day01.solve1(input) == 1_006_875
  end

  test "solve2" do
    {:ok, input} = File.read("test/input2020_1")
    assert Aoc2020Day01.solve2(input) == 165_026_160
  end
end

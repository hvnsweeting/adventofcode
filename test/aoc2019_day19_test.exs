defmodule Aoc2019Day19Test do
  use ExUnit.Case

  @tag slow: true
  test "solve1" do
    {:ok, input} = File.read("test/input2019_19.txt")
    assert Aoc2019Day19.solve1(input) == 162
  end

  @tag slow: true
  @tag timeout: :infinity
  test "solve2" do
    {:ok, input} = File.read("test/input2019_19.txt")
    assert Aoc2019Day19.solve2(input) == 13_021_056
  end
end

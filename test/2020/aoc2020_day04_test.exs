defmodule Aoc2020Day04Test do
  use ExUnit.Case

  test "p1" do
    {:ok, input} = File.read("test/input2020_4")
    assert Aoc2020Day04.solve1(input) == 245
  end

  test "p2" do
    {:ok, input} = File.read("test/input2020_4")
    assert Aoc2020Day04.solve2(input) == 133
  end
end

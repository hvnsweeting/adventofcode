defmodule Aoc2020Day06Test do
  use ExUnit.Case

  test "p1" do
    {:ok, input} = File.read("test/input2020_6")
    assert Aoc2020Day06.solve1(input) == 6947
  end

  test "p2" do
    {:ok, input} = File.read("test/input2020_6")
    assert Aoc2020Day06.solve2(input) == 3398
  end
end

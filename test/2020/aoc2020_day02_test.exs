defmodule Aoc2020Day02Test do
  use ExUnit.Case

  test "solve1" do
    {:ok, input} = File.read("test/input2020_2")
    assert Aoc2020Day02.solve1(input) == 517
  end

  test "solve2" do
    {:ok, input} = File.read("test/input2020_2")
    assert Aoc2020Day02.solve2(input) == 284
  end
end

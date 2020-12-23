defmodule Aoc2020Day23Test do
  use ExUnit.Case

  @input " 389125467 "
  test "1" do
    assert Aoc2020Day23.solve1(@input) == "67384529"

    {:ok, input} = File.read("test/input2020_23")
    assert Aoc2020Day23.solve1(input) == "47382659"
  end

  @tag slow: true
  @tag timeout: :infinity
  test "2" do
    assert Aoc2020Day23.solve2(@input) == 149_245_887_792

    {:ok, input} = File.read("test/input2020_23")
    assert Aoc2020Day23.solve2(input) == 42_271_866_720
  end
end

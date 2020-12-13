defmodule Aoc2020Day13Test do
  use ExUnit.Case

  test "1" do
    input = "
939
7,13,x,x,59,x,31,19
    "
    assert Aoc2020Day13.solve1(input) == 295
    {:ok, input} = File.read("test/input2020_13")
    assert Aoc2020Day13.solve1(input) == 115
  end

  @tag timeout: :infinity
  test "2" do
    input = "
939
17,x,13,19"
    assert Aoc2020Day13.solve2(input) == 3417
    {:ok, input} = File.read("test/input2020_13")
    assert Aoc2020Day13.solve2(input) == 756_261_495_958_122
  end
end

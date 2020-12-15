defmodule Aoc2020Day15Test do
  use ExUnit.Case

  @tag timeout: :infinity
  test "2" do
    # input = "0,3,6"
    # assert Aoc2020Day15.solve2(input) == 175_594
    {:ok, input} = File.read("test/input2020_15")
    assert Aoc2020Day15.solve2(input) == 3_745_954
  end
end

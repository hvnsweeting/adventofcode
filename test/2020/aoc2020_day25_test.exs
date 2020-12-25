defmodule Aoc2020Day25Test do
  use ExUnit.Case

  test "1" do
    input = "
5764801
17807724"

    {:ok, input} = File.read("test/input2020_25")
    assert Aoc2020Day25.solve1(input) == 354_320
  end
end

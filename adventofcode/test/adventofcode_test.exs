defmodule AdventofcodeTest do
  use ExUnit.Case
  doctest Adventofcode

  test "greets the world" do
    assert Adventofcode.hello() == :world
  end

  test "cell from 1,3 4x4" do
    assert Adventofcode.claim_to_set("#1 @ 1,3: 4x4") ==
             MapSet.new(for x <- 1..4, y <- 3..6, do: {x, y})
  end

  test "square inch overlap " do
    claims = "#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2" |> String.split("\n")
    assert Adventofcode.square_inches_overlap(claims) == 4
  end

  test "overlap_count" do
    claims = "#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2" |> String.split("\n")
    claims_set = claims |> Enum.map(&Adventofcode.claim_to_set/1)
    assert Enum.map(claims_set, fn x -> Adventofcode.overlap(x, claims_set) end) == [2, 2, 1]
  end

  test "find does not overlap" do
    claims = "#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2" |> String.split("\n")
    assert Adventofcode.find_claim_does_not_overlap(claims) == "#3 @ 5,5: 2x2"
  end
end

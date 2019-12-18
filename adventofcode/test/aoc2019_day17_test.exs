defmodule Aoc2019Day17Test do
  use ExUnit.Case

  @testview "..#..........
..#..........
#######...###
#.#...#...#.#
#############
..#...#...#..
    ..#####...^.."

  test "intersects locations" do
    assert Aoc2019Day17.find_intersects(@testview) == [{2, 2}, {6, 4}, {2, 4}, {10, 4}]
  end

  test "sum_of_aligment_params example intersects" do
    assert Aoc2019Day17.sum_of_aligment_params([{2, 2}, {6, 4}, {2, 4}, {10, 4}]) == 76
  end

  test "sum_of_aligment_params example view" do
    assert Aoc2019Day17.find_intersects(@testview) |> Aoc2019Day17.sum_of_aligment_params() == 76
  end

  test "test solve1" do
    {:ok, input} = File.read("test/input2019_17.txt")
    assert Aoc2019Day17.solve1(input) == 4688
  end
end

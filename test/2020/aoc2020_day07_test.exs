defmodule Aoc2020Day07Test do
  use ExUnit.Case

  test "p1" do
    input = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
    "
    assert Aoc2020Day07.solve1(input) == 4
    {:ok, input} = File.read("test/input2020_7")
    assert Aoc2020Day07.solve1(input) == 242
  end

  test "p2" do
    {:ok, input} = File.read("test/input2020_7")
    assert Aoc2020Day07.solve2(input) == 176_035
  end
end

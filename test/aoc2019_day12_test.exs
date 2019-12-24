defmodule Aoc2019Day12Test do
  use ExUnit.Case
  @sample_input "<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>"

  @sample_input2 "<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>"

  test "apply gravity" do
    [a, b, c, d] = Aoc2019Day12.parse_input(@sample_input)

    assert Aoc2019Day12.apply_gravity(a, b, c, d) == [
             {{-1, 0, 2}, {3, -1, -1}},
             {{2, -10, -7}, {1, 3, 3}},
             {{4, -8, 8}, {-3, 1, -3}},
             {{3, 5, -1}, {-1, -3, 1}}
           ]
  end

  test "apply 10 times" do
    [a, b, c, d] = Aoc2019Day12.parse_input(@sample_input)

    assert Aoc2019Day12.apply(a, b, c, d, 10) == [
             {{2, 1, -3}, {-3, -2, 1}},
             {{1, -8, 0}, {-1, 1, 3}},
             {{3, -6, 1}, {3, 2, -3}},
             {{2, 0, 4}, {1, -1, -1}}
           ]
  end

  test "total energy for all moons after 10 steps produces the total energy in the system is 179 " do
    assert Aoc2019Day12.solve1(@sample_input, 10) == 179
  end

  test "Sample 2 total energy for all moons after 100 steps produces the total energy in the system is 1940 " do
    assert Aoc2019Day12.solve1(@sample_input2, 100) == 1940
  end

  test "solve1" do
    {:ok, input} = File.read("test/input2019_12.txt")
    assert Aoc2019Day12.solve1(input, 1000) == 10189
  end
end

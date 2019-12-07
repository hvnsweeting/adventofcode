defmodule Aoc2019Day2Test do
  use ExUnit.Case
  doctest Aoc2019Day2

  test "Program 1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2)." do
    assert Aoc2019Day2.run("1,0,0,0,99") == Aoc2019Day2.state_to_int_list("2,0,0,0,99")
  end

  test "Program 2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6). " do
    assert Aoc2019Day2.run(" 2,3,0,3,99 ") == Aoc2019Day2.state_to_int_list(" 2,3,0,6,99 ")
  end

  test "2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801)." do
    assert Aoc2019Day2.run(" 2,4,4,5,99,0 ") == Aoc2019Day2.state_to_int_list(" 2,4,4,5,99,9801 ")
  end

  test "1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99. " do
    assert Aoc2019Day2.run("1,1,1,4,99,5,6,0,99 ") ==
             Aoc2019Day2.state_to_int_list("30,1,1,4,2,5,6,0,99")
  end

  test "Program 1,9,10,3,2,3,11,0,99,30,40,50" do
    assert Aoc2019Day2.run("1,9,10,3,2,3,11,0,99,30,40,50") ==
             Aoc2019Day2.state_to_int_list("3500,9,10,70, 2,3,11,0, 99, 30,40,50")
  end

  test "Solve part 1" do
    {:ok, text} = File.read("test/input2019_02_1.txt")
    assert Aoc2019Day2.solve_part_1(text) == 3_850_704
  end

  test "Solve part 2" do
    {:ok, text} = File.read("test/input2019_02_1.txt")
    assert Aoc2019Day2.solve_part_2(text) == 6718
  end
end

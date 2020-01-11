defmodule Aoc2019Day05Test do
  use ExUnit.Case, async: true
  import Intcode

  test "Day 5 part 1" do
    {:ok, text} = File.read("test/input2019_05_1.txt")
    assert Aoc2019Day5.solve_part_1(text) == 2_845_163
  end

  test "Day 5 part 2" do
    {:ok, text} = File.read("test/input2019_05_1.txt")
    assert Aoc2019Day5.solve_part_2(text) == 9_436_229
  end

  @tag hihi: true
  test "jump tests 3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 that take an input, then output 0 if the input was zero or 1 if the input was non-zero:" do
    program = "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
    assert check_output(program, [0]) == 0
    assert check_output(program, [1]) == 1
  end

  test "test programs that take one input, compare it to the value 8, and then produce one output" do
    # - Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    program = "3,9,8,9,10,9,4,9,99,-1,8"
    assert check_output(program, [8]) == 1
    assert check_output(program, [5]) == 0

    # - Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
    program = "3,9,7,9,10,9,4,9,99,-1,8"
    assert check_output(program, [5]) == 1
    assert check_output(program, [10]) == 0
  end

  test "The program will then output 999 if the input value is below 8, output 1000 if the input value is equal to 8, or output 1001 if the input value is greater than 8" do
    program =
      "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

    assert check_output(program, [4]) == 999
    assert check_output(program, [8]) == 1000
    assert check_output(program, [10]) == 1001
  end
end

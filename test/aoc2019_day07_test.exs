defmodule Aoc2019Day07Test do
  use ExUnit.Case, async: true

  test "test Max thruster signal 43210 (from phase setting sequence 4,3,2,1,0)" do
    program = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"

    assert Aoc2019Day7.thruster_signal(program, 0, [4, 3, 2, 1, 0]) == 43210

    assert Aoc2019Day7.thruster_signal(program, 0, [4, 3, 2, 1, 0]) ==
             Aoc2019Day7.max_thruster_signal(program, 0, [0, 1, 2, 3, 4])
  end

  test "Max thruster signal 54321 (from phase setting sequence 0,1,2,3,4)" do
    program = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"
    assert Aoc2019Day7.max_thruster_signal(program, 0, [0, 1, 2, 3, 4]) == 54321
  end

  test "Max thruster signal 65210 (from phase setting sequence 1,0,4,3,2)" do
    program =
      "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"

    assert Aoc2019Day7.max_thruster_signal(program, 0, [1, 0, 4, 3, 2]) == 65210
  end

  test "Max thruster signal 139629729 (from phase setting sequence 9,8,7,6,5)" do
    program =
      "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"

    assert Aoc2019Day7.thruster_signal_loop(program, 0, [9, 8, 7, 6, 5]) == 139_629_729
  end

  test "test solve_part_1" do
    {:ok, text} = File.read("test/input2019_07_1.txt")
    assert Aoc2019Day7.max_thruster_signal(text, 0, [0, 1, 2, 3, 4]) == 844_468
  end

  test "solve part 2" do
    {:ok, text} = File.read("test/input2019_07_1.txt")
    assert Aoc2019Day7.solve2(text, 0, [5, 6, 7, 8, 9]) == 4_215_746
  end
end

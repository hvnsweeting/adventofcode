defmodule Aoc2019Day5 do
  import Intcode

  def solve_part_1() do
    {:ok, text} = File.read("test/input2019_05_1.txt")
    # |> elem(1)
    text |> run(1)
  end

  def solve_part_2() do
    {:ok, text} = File.read("test/input2019_05_1.txt")
    # |> elem(1)
    jump = "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
    run(jump, 1)
    compare = "3,9,8,9,10,9,4,9,99,-1,8"
    run(compare, 8)
    run(compare, 7)

    test_text = """
    3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    """

    a = test_text |> run(7)
    b = test_text |> run(8)
    c = test_text |> run(9)
    text |> run(5)
  end
end

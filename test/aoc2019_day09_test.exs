defmodule Aoc2019Day09Test do
  use ExUnit.Case

  test "  109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 takes no input and produces a copy of itself as output." do
    state = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"

    assert Aoc2019Day9.check_raw_output(state, []) ==
             String.split(state, ",") |> Enum.map(&String.to_integer/1)
  end

  test "1102,34915192,34915192,7,4,7,99,0 should output a 16-digit number. " do
    assert Aoc2019Day9.check_output("1102,34915192,34915192,7,4,7,99,0", [])
           |> Integer.to_string()
           |> String.length() == 16
  end

  test "104,1125899906842624,99 should output the large number in the middle. " do
    assert Aoc2019Day9.check_output("104,1125899906842624,99", []) == 1_125_899_906_842_624
  end

  test "solve 1" do
    {:ok, text} = File.read("test/input2019_09_1.txt")
    assert Aoc2019Day9.solve1(text) == [3_497_884_671]
  end

  test "solve 2" do
    {:ok, text} = File.read("test/input2019_09_1.txt")
    assert Aoc2019Day9.solve2(text) == [46470]
  end
end

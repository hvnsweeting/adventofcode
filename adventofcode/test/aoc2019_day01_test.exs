defmodule Aoc2019Day1Test do
  use ExUnit.Case
  doctest Aoc2019Day1

  test "fuel for mass of 12 is 2" do
    assert Aoc2019Day1.calculate_fuel(12) == 2
  end

  test "fuel for mass of 14 is 2" do
    assert Aoc2019Day1.calculate_fuel(14) == 2
  end

  test "fuel for mass of 1969 is 654" do
    assert Aoc2019Day1.calculate_fuel(1969) == 654
  end

  test "For a mass of 100756, the fuel required is 33583." do
    assert Aoc2019Day1.calculate_fuel(100_756) == 33583
  end

  test "total fuel for 12 14 1969 is 2 + 2 + 654 = 658" do
    assert Aoc2019Day1.sum_of_fuel([12, 14, 1969]) == 658
  end

  test "solve 1_1" do
    {:ok, text} = File.read("test/input2019_01_1.txt")
    result = text |> String.split() |> Enum.map(&String.to_integer/1) |> Aoc2019Day1.solve_1()
    assert result == 3_323_874
  end
end

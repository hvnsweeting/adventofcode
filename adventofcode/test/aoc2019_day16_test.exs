defmodule Aoc2019Day16Test do
  use ExUnit.Case

  test "Then, only the ones digit is kept: 38 becomes 8" do
    assert Aoc2019Day16.ones_digit(38) == 8
  end

  test "-17 becomes 7" do
    assert Aoc2019Day16.ones_digit(-17) == 7
  end

  test "if the input list were 9, 8, 7, 6, 5 and the pattern for a given element were 1, 2, 3, the result would be 9*1 + 8*2 + 7*3 + 6*1 + 5*2" do
    input_list = [9, 8, 7, 6, 5]
    pattern = [1, 2, 3]
    assert Aoc2019Day16.make_element(input_list, pattern) == 9 * 1 + 8 * 2 + 7 * 3 + 6 * 1 + 5 * 2
  end

  test "Raw pattern for 3rd elem is 0, 0, 0, 1, 1, 1, 0, 0, 0, -1, -1, -1 from base pattern 0, 1, 0, -1. " do
    nth = 3
    base_pattern = [0, 1, 0, -1]

    assert Aoc2019Day16.raw_pattern(base_pattern, nth) |> Enum.take(12) == [
             0,
             0,
             0,
             1,
             1,
             1,
             0,
             0,
             0,
             -1,
             -1,
             -1
           ]
  end

  test "Input signal 12345678 -> FFT After 1 phase: 48226158" do
    assert Aoc2019Day16.apply_phase("12345678") == "48226158"
  end

  test "Input signal 12345678 -> FFT After 2 phase: 34040438" do
    assert Aoc2019Day16.apply_phases("12345678", 2) == "34040438"
  end

  test "Input signal 12345678 -> FFT After 3 phase: 34040438" do
    assert Aoc2019Day16.apply_phases("12345678", 3) == "03415518"
  end

  test "Input signal 12345678 -> FFT After 4 phase: 34040438" do
    assert Aoc2019Day16.apply_phases("12345678", 4) == "01029498"
  end

  test "Input signal 80871224585914546619083218645595 -> FFT After 100 phases: 24176176" do
    assert Aoc2019Day16.apply_phases("80871224585914546619083218645595", 100)
           |> String.slice(0, 8) == "24176176"
  end

  test "solve 1" do
    {:ok, input} = File.read("test/input2019_16_1.txt")
    assert Aoc2019Day16.solve1(input) == "37153056"
  end
end

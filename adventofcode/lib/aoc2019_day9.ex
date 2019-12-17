defmodule Aoc2019Day9 do
  def solve1(input) do
    Intcode.check_raw_output(input, [1])
  end

  def solve2(input) do
    Intcode.check_raw_output(input, [2])
  end

  def check_output(state, input) do
    Intcode.check_output(state, input)
  end

  def check_raw_output(state, input) do
    Intcode.check_raw_output(state, input)
  end
end

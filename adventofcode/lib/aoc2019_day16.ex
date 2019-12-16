defmodule Aoc2019Day16 do
  # https://adventofcode.com/2019/day/16
  def solve1(text) do
    apply_phases(text, 100) |> String.slice(0, 8)
  end

  def apply_phases(text, 0) do
    text
  end

  def apply_phases(text, phases) do
    apply_phases(apply_phase(text), phases - 1)
  end

  def apply_phase(text) do
    input = text |> String.trim() |> String.to_charlist() |> Enum.map(fn d -> d - ?0 end)

    1..length(input)
    |> Enum.map(fn nth ->
      real_pattern = Stream.drop(raw_pattern([0, 1, 0, -1], nth), 1)
      # |> Enum.take(10)
      real_pattern
      make_element(input, real_pattern) |> ones_digit
    end)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
  end

  def ones_digit(number) do
    rem(abs(number), 10)
  end

  def make_element(input_list, pattern) do
    Enum.zip(input_list, Stream.cycle(pattern)) |> Enum.map(fn {e, p} -> e * p end) |> Enum.sum()
  end

  def raw_pattern(base_pattern, nth) do
    Stream.flat_map(base_pattern, fn x -> Stream.cycle([x]) |> Enum.take(nth) end)
    |> Stream.cycle()
  end
end

defmodule Aoc2019Day16 do
  # https://adventofcode.com/2019/day/16
  def as_list(text) do
    text |> String.trim() |> String.to_charlist() |> Enum.map(fn d -> d - ?0 end)
  end

  def apply_phases(text, c, drop \\ 1)

  def apply_phases(text, 0, drop) do
    text
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
  end

  def apply_phases(text, phases, drop) do
    apply_phases(apply_phase(text, drop), phases - 1, drop)
  end

  def apply_phase(input, drop \\ 1) do
    #IO.inspect({"Input length", length(input), "drop", drop, drop..length(input)})

    drop..length(input)
    |> Enum.map(fn nth ->
      real_pattern = Stream.drop(raw_pattern([0, 1, 0, -1], nth), 1)
      # IO.inspect(Enum.take(real_pattern, 20))
      make_element(input, real_pattern) |> ones_digit
    end)
  end

  def ones_digit(number) do
    rem(abs(number), 10)
  end

  def make_element(input_list, pattern) do
    Stream.zip(input_list, Stream.cycle(pattern))
    |> Stream.map(fn {e, p} -> e * p end)
    |> Enum.sum()

    # |> Enum.drop(skip)
    # IO.inspect({"Remain", length(v)})
    # v |> Enum.sum()
  end

  def raw_pattern(base_pattern, nth) do
    Stream.flat_map(base_pattern, fn x -> Stream.cycle([x]) |> Enum.take(nth) end)
    |> Stream.cycle()
  end

  def solve1(text, phases \\ 100) do
    input = as_list(text)
    apply_phases(input, phases) |> String.slice(0, 8)
  end

  def solve2(text, phases \\ 100) do
    offset = String.to_integer(String.slice(text, 0, 7))
    IO.inspect({"OFFSET", offset})

    [text]
    |> Stream.cycle()
    |> Enum.take(10000)
    |> Enum.join()
    |> as_list
    |> apply_phases(100, offset)
  end
end

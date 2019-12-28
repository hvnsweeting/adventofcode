defmodule Aoc2019Day16 do
  # https://adventofcode.com/2019/day/16
  def as_list(text) do
    text
    |> String.trim()
    |> String.to_charlist()
    |> Enum.map(fn d -> d - ?0 end)
    |> Enum.with_index(1)
  end

  @doc """
  This originally used for part 1 but now keep for reference only after refactor
  """
  def raw_pattern(base_pattern, nth) do
    Stream.flat_map(base_pattern, fn x -> Stream.cycle([x]) |> Enum.take(nth) end)
    |> Stream.cycle()
  end


  def doone(numbers) do
    numbers_with_index = Enum.with_index(numbers)

    Enum.map(numbers_with_index, fn {{_, nth}, local_index} ->
      calculate(numbers, nth, local_index)
    end)
  end

  def ones_digit(number) do
    rem(abs(number), 10)
  end

  def apply_phases(text, 0) do
    text
    |> Enum.map(fn {n, _} -> n end)
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
  end

  def apply_phases(text, phases) do
    output = doone(text)
    apply_phases(output, phases - 1)
  end

  @doc """
  Instead of calculate 0 1 0 -1 stream and zip with numbers,
  this calculates result base on pattern of 0 1 0 -1
  """
  def calculate(numbers, nth, drop \\ 0) do
    dropped = numbers |> Enum.drop(drop)

    r =
      dropped
      |> Enum.reduce(0, fn x, acc ->
        {n, idx} = x
        idx = idx + 1
        remainder = rem(idx, nth * 4)

        v =
          case trunc(:math.ceil(remainder / nth)) do
            4 -> -n
            1 -> 0
            2 -> n
            3 -> 0
            0 -> -n
          end

        acc + v
      end)
      # |> IO.inspect #|> ones_digit
      |> ones_digit

    {r, nth}
  end

  @doc """
  Part2 caculate in a totally different way. The input is huge, using
  method in part1 would never work (too slow).
  This method based on lot of observations:
  - row nth, there would be n 1 numbers in pattern
  - row nth, result would depends on col nth forward, because before it is all multiply with 0
  - base on part 2 examples and input, the offset is big enough to guarantee
  all numbers would still part of multiply by 1. E.g offset 5_000_000 on 500_000
  remaining number (ie total lengh 5_500_000)
  - as we care only about 1 last digit, there is no need to calculate huge sum,
  just need to ensure the part ensure last digit -> add 10 to it to avoid
  negative
  """
  def generate_new_number(numbers) do
    sum_base = ones_digit(Enum.sum(numbers))

    numbers
    |> Enum.reduce({[], sum_base, 0}, fn n, {ls, cumsum, last} ->
      {[ones_digit(10 + cumsum - last) | ls], 10 + cumsum - last, n}
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  def loop(text, 0) do
    text
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
  end

  def loop(text, phases) do
    output = generate_new_number(text)
    loop(output, phases - 1)
  end

  def solve1(text, phases \\ 100) do
    input = as_list(text)
    apply_phases(input, phases) |> String.slice(0, 8)
  end

  def solve2(input, phases \\ 100) do
    offset = String.to_integer(String.slice(input, 0, 7))
    inp = input |> String.trim()

    inp =
      inp
      |> String.to_charlist()
      |> Enum.map(fn d -> d - ?0 end)
      |> Stream.cycle()
      |> Enum.take(10000 * String.length(inp))
      |> Enum.drop(offset)

    Aoc2019Day16.loop(inp, phases) |> String.slice(0, 8)
  end
end

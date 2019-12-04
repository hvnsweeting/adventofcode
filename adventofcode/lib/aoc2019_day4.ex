defmodule Aoc2019Day4 do
  @moduledoc """
  https://adventofcode.com/2019/day/4
  """

  def has_six_digits_number?([h | t]) do
    has_six_digits_number?([h | t], 0)
  end

  defp has_six_digits_number?([], count) do
    if count == 6 do
      true
    else
      false
    end
  end

  defp has_six_digits_number?([h | t], count) do
    if ?0 <= h && h <= ?9 do
      has_six_digits_number?(t, count + 1)
    else
      false
    end
  end

  def has_two_adjacent_digits?([]) do
    false
  end

  def has_two_adjacent_digits?([h | t]) do
    next = List.first(t)

    if next == nil do
      false
    else
      if h == next do
        true
      else
        has_two_adjacent_digits?(t)
      end
    end
  end

  def is_never_decrease?([h | t]) do
    next = List.first(t)

    if next == nil do
      true
    else
      if h > next do
        false
      else
        is_never_decrease?(t)
      end
    end
  end

  def is_within_range?(password, start, stop) do
    n = String.to_integer(password)
    start <= n && n <= stop
  end

  def valid_password?(password, start, stop) do
    pw_charlist = String.to_charlist(password)

    Enum.all?([
      has_six_digits_number?(pw_charlist),
      is_within_range?(password, start, stop),
      has_two_adjacent_digits?(String.to_charlist(password)),
      is_never_decrease?(String.to_charlist(password))
    ])
  end

  def solve_part_1(start, stop) do
    start..stop
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce(0, fn x, acc ->
      if valid_password?(x, start, stop) do
        acc + 1
      else
        acc
      end
    end)
  end
end

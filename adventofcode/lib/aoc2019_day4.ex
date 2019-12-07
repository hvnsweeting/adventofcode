defmodule Aoc2019Day4 do
  @moduledoc """
  https://adventofcode.com/2019/day/4
  """

  def has_at_least_to_same_adjacent_digits?([]) do
    false
  end

  def has_at_least_to_same_adjacent_digits?([h | t]) do
    next = List.first(t)

    if next == nil do
      false
    else
      if h == next do
        true
      else
        has_at_least_to_same_adjacent_digits?(t)
      end
    end
  end

  def has_two_adjacent_digits?([h | t]) do
    has_two_adjacent_digits?(t, h, 1, [])
  end

  defp has_two_adjacent_digits?([], tmp, count, acc) do
    final = acc ++ [{tmp, count}]
    good = final |> Enum.filter(fn {x, count} -> count == 2 end)
    length(good) > 0
  end

  defp has_two_adjacent_digits?([h | t], tmp, count, acc) do
    if h == tmp do
      has_two_adjacent_digits?(t, h, count + 1, acc)
    else
      has_two_adjacent_digits?(t, h, 1, acc ++ [{tmp, count}])
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
    Enum.all?([
      is_within_range?(password, start, stop),
      has_at_least_to_same_adjacent_digits?(String.to_charlist(password)),
      is_never_decrease?(String.to_charlist(password))
    ])
  end

  def valid_password2?(password, start, stop) do
    Enum.all?([
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

  def solve_part_2(start, stop) do
    start..stop
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce(0, fn x, acc ->
      if valid_password2?(x, start, stop) do
        acc + 1
      else
        acc
      end
    end)
  end
end

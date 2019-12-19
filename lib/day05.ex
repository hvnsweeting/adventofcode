defmodule Day05 do
  # https://adventofcode.com/2018/day/5
  def hello() do
    :hello
  end

  def destroy?(unit1, unit2) do
    diff(unit1, unit2) == 32
  end

  # O(n) solution
  # put thing we checked to a stack
  # if we meet new char, check only top of stack , destroy or go ahead
  def react_stack(polymer) do
    do_react_stack(String.to_charlist(polymer), []) |> List.to_string()
  end

  defp do_react_stack([], stack) do
    stack
  end

  defp do_react_stack([h | t], []) do
    do_react_stack(t, [h])
  end

  defp do_react_stack([h | t], stack) do
    if destroy?(h, List.last(stack)) do
      do_react_stack(t, List.delete_at(stack, -1))
    else
      do_react_stack(t, stack ++ [h])
    end
  end

  # Naive implementation, too slow so have to think of react_stack O(n) solution
  def react(polymer) do
    once = react_once(polymer)

    if once == polymer do
      polymer
    else
      react(once)
    end
  end

  def react_once(s) do
    String.to_charlist(s) |> do_react_once(nil, []) |> List.to_string()
  end

  defp do_react_once([], last_result, result) do
    if last_result == nil do
      result
    else
      result ++ [last_result]
    end
  end

  defp do_react_once([h | t], nil, result) do
    do_react_once(t, h, result)
  end

  defp do_react_once([h | t], last_unit, result) do
    if destroy?(h, last_unit) do
      # result ++ t
      do_react_once(t, nil, result)
    else
      do_react_once(t, h, result ++ [last_unit])
    end
  end

  # This react once per iterate is super inefficient
  # defp do_react_once([h|t], last_unit, result) do
  #  if destroy?(h, last_unit) do
  #    result ++ t
  #  else
  #    do_react_once(t, h, result ++ [last_unit])
  #  end
  # end

  def diff(c1, c2) do
    abs(c1 - c2)
  end

  def char_diff(c1, c2) do
    abs(List.first(c1) - List.first(c2))
  end

  # This is not super fast but still under 1 min, may have way to optimize it
  def solve_part2(polymer) do
    polymer
    |> all_uniq_units
    |> Enum.map(fn c -> remove_one_unit_type(c, polymer) end)
    |> Enum.min()
  end

  def remove_one_unit_type(unit_type, polymer) do
    unit_order = unit_type

    other_polarity =
      if unit_order >= List.first('a') do
        unit_order - 32
      else
        unit_order + 32
      end

    String.replace(polymer, List.to_string([unit_order]), "")
    |> String.replace(List.to_string([other_polarity]), "")
    |> react_stack
    |> String.length()
  end

  def all_uniq_units(polymer) do
    polymer |> String.downcase() |> String.to_charlist() |> MapSet.new() |> MapSet.to_list()
  end
end

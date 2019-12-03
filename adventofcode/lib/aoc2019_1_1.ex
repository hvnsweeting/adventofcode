defmodule Aoc2019Day1 do
  @moduledoc """
  Documentation for Aoc2019.
  """

  @doc """
      Fuel required to launch a given module is based on its mass. Specifically, to find the fuel required for a module, take its mass, divide by three, round down, and subtract 2.

    For example:

        For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
        For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
        For a mass of 1969, the fuel required is 654.
        For a mass of 100756, the fuel required is 33583.

    The Fuel Counter-Upper needs to know the total fuel requirement. To find it, individually calculate the fuel needed for the mass of each module (your puzzle input), then add together all the fuel values.

    What is the sum of the fuel requirements for all of the modules on your spacecraft?
  """

  def calculate_fuel(mass) do
    {int, _} = Integer.parse(Float.to_string(mass / 3))
    int - 2
  end

  def sum_of_fuel(modules) do
    modules |> Enum.map(&calculate_fuel/1) |> Enum.sum()
  end

  def solve_1(modules) do
    sum_of_fuel(modules)
  end

  @doc """
  total_fuel calculate fuel requirements for mass, and the fuel itself
  turtle all they way down.

  Fuel itself requires fuel just like a module - take its mass, divide by three, round down, and subtract 2. However, that fuel also requires fuel, and that fuel requires fuel, and so on. Any mass that would require negative fuel should instead be treated as if it requires zero fuel; the remaining mass, if any, is instead handled by wishing really hard, which has no mass and is outside the scope of this calculation.
  """
  def total_fuel(mass, acc) do
    fuel = calculate_fuel(mass)

    if fuel <= 0 do
      acc
    else
      total_fuel(fuel, acc + fuel)
    end
  end

  def total_fuel(mass) do
    total_fuel(mass, 0)
  end

  def sum_total_fuel(modules) do
    modules |> Enum.map(&total_fuel/1) |> Enum.sum()
  end

  def solve_2(modules) do
    sum_total_fuel(modules)
  end
end

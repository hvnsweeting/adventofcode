defmodule Aoc2019Day12 do
  def solve1(input, steps \\ 10) do
    [a, b, c, d] = parse_input(input)
    apply(a, b, c, d, steps) |> Enum.map(&total_energy_for_a_moon/1) |> Enum.sum()
  end

  def parse_input(input) do
    [a, b, c, d] =
      input
      |> String.trim()
      |> String.split("\n", [:trim, true])
      |> Enum.map(&parse/1)
      |> Enum.map(fn x -> {x, {0, 0, 0}} end)
  end

  defp parse(s) do
    d = Regex.named_captures(~r/x=(?<x>-?\d+), y=(?<y>-?\d+), z=(?<z>-?\d+)>/, s)
    {String.to_integer(d["x"]), String.to_integer(d["y"]), String.to_integer(d["z"])}
  end

  def apply_gravity(a, b, c, d) do
    moons = [a, b, c, d]

    moons
    |> Enum.map(fn {pos1, vel1} ->
      {x, y, z} = pos1
      {vx, vy, vz} = vel1

      newvel =
        Enum.reduce(moons, vel1, fn {pos2, _}, acc ->
          {vx, vy, vz} = acc
          {x2, y2, z2} = pos2

          vx =
            cond do
              x > x2 -> vx - 1
              x == x2 -> vx
              x < x2 -> vx + 1
            end

          vy =
            cond do
              y > y2 -> vy - 1
              y == y2 -> vy
              y < y2 -> vy + 1
            end

          vz =
            cond do
              z > z2 -> vz - 1
              z == z2 -> vz
              z < z2 -> vz + 1
            end

          {vx, vy, vz}
        end)

      {pos1, newvel}
    end)
  end

  def apply(a, b, c, d, n) do
    1..n
    |> Enum.reduce([a, b, c, d], fn _, acc ->
      [e, f, g, h] = acc
      do_one_step(e, f, g, h)
    end)
  end

  defp do_one_step(a, b, c, d) do
    # TODO
    # apply velocity
    apply_gravity(a, b, c, d)
    |> Enum.map(fn {pos, vel} ->
      {x, y, z} = pos
      {vx, vy, vz} = vel
      {{x + vx, y + vy, z + vz}, vel}
    end)
  end

  @doc """
  The total energy for a single moon is its potential energy multiplied by its kinetic energy.
  """
  def total_energy_for_a_moon({pos, vel}) do
    sum_of_absolute_xyz(pos) * sum_of_absolute_xyz(vel)
  end

  @doc """
  A moon's potential energy is the sum of the absolute values of its x, y, and z position coordinates.
  A moon's kinetic energy is the sum of the absolute values of its velocity coordinates.
  """
  defp sum_of_absolute_xyz({x, y, z}) do
    abs(x) + abs(y) + abs(z)
  end
end

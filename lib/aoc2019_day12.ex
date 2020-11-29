defmodule Aoc2019Day12 do
  def solve1(input, steps \\ 10) do
    [a, b, c, d] = parse_input(input)
    do_n_steps(a, b, c, d, steps) |> Enum.map(&total_energy_for_a_moon/1) |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", [:trim, true])
    |> Enum.map(&parse/1)
    |> Enum.map(fn {x, y, z} -> {{x, y, z}, {0, 0, 0}} end)
  end

  defp parse(s) do
    d = Regex.named_captures(~r/x=(?<x>-?\d+), y=(?<y>-?\d+), z=(?<z>-?\d+)>/, s)
    {String.to_integer(d["x"]), String.to_integer(d["y"]), String.to_integer(d["z"])}
  end

  def apply_gravity(moons) do
    moons
    |> Enum.map(fn {{x, y, z}, {vx, vy, vz}} ->
      newvel =
        Enum.reduce(moons, {vx, vy, vz}, fn {pos2, _}, acc ->
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

      {{x, y, z}, newvel}
    end)
  end

  def do_n_steps(a, b, c, d, n \\ 1) do
    1..n
    |> Enum.reduce([a, b, c, d], fn _, [e, f, g, h] ->
      do_one_step(e, f, g, h)
      # |> IO.inspect(label: "step")
    end)
  end

  defp do_one_step(a, b, c, d) do
    [a, b, c, d]
    |> apply_gravity
    |> Enum.map(&apply_velocity/1)
  end

  defp apply_velocity({{x, y, z}, {vx, vy, vz}}) do
    {{x + vx, y + vy, z + vz}, {vx, vy, vz}}
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

  def steps_to_exactly_match(moons, stop_condition) do
    steps_to_exactly_match(moons, moons, 0, stop_condition)
  end

  defp dimension_match?([e, f, g, h], [a0, b0, c0, d0], get_a_dimension) do
    get_a_dimension.([e, f, g, h]) == get_a_dimension.([a0, b0, c0, d0])
  end

  defp x_dimension_match?(ms1, ms2) do
    dimension_match?(ms1, ms2, &get_x/1)
  end

  defp y_dimension_match?(ms1, ms2) do
    dimension_match?(ms1, ms2, &get_y/1)
  end

  defp z_dimension_match?(ms1, ms2) do
    dimension_match?(ms1, ms2, &get_z/1)
  end

  defp get_x(moons) do
    moons
    |> Enum.map(fn {{x, _y, _z}, {vx, _vy, _vz}} -> {x, vx} end)
  end

  defp get_y(moons) do
    moons
    |> Enum.map(fn {{_x, y, _z}, {_vx, vy, _vz}} -> {y, vy} end)
  end

  defp get_z(moons) do
    moons
    |> Enum.map(fn {{_x, _y, z}, {_vx, _vy, vz}} -> {z, vz} end)
  end

  defp steps_to_exactly_match([a, b, c, d], [a0, b0, c0, d0], steps, stop_condition) do
    [e, f, g, h] = do_n_steps(a, b, c, d, 1)

    if stop_condition.([e, f, g, h], [a0, b0, c0, d0]) do
      steps + 1
    else
      steps_to_exactly_match([e, f, g, h], [a0, b0, c0, d0], steps + 1, stop_condition)
    end
  end

  def steps_to_exactly_match([a, b, c, d]) do
    x_cycle = steps_to_exactly_match([a, b, c, d], &x_dimension_match?/2)
    y_cycle = steps_to_exactly_match([a, b, c, d], &y_dimension_match?/2)
    z_cycle = steps_to_exactly_match([a, b, c, d], &z_dimension_match?/2)
    lcm(lcm(x_cycle, y_cycle), z_cycle)
  end

  defp lcm(a, b) do
    trunc(a * b / gcd(a, b))
  end

  defp gcd(a, 0) do
    a
  end

  defp gcd(a, b) do
    gcd(b, rem(a, b))
  end

  def solve2(input) do
    [a, b, c, d] = parse_input(input)
    steps_to_exactly_match([a, b, c, d])
  end
end

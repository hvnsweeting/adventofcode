defmodule Aoc2020Day13 do
  import Enum

  def read_input(input) do
    i =
      input
      |> String.trim()
      |> String.split("\n", trim: true)

    [n, bus] = i

    {String.to_integer(n),
     bus |> String.split(",") |> filter(fn x -> x != "x" end) |> map(&String.to_integer/1)}
  end

  def solve1(input) do
    {m, bus} =
      input
      |> read_input

    {b, w} =
      bus
      |> map(fn x -> {x, x - rem(m, x)} end)
      |> Enum.min_by(fn {_, v} -> v end)

    b * w
  end

  def solve2(input) do
    [_, bus] =
      input
      |> String.trim()
      |> String.split("\n", trim: true)

    bus =
      bus
      |> String.split(",")
      |> with_index
      |> filter(fn {x, _} -> x != "x" end)
      |> map(fn {x, i} -> {String.to_integer(x), i} end)

    bus
    |> reduce({0, 1}, &solve/2)
    |> elem(0)
  end

  def solve({"x", _}, state), do: state

  def solve({bus, idx}, {t, step}) do
    # IO.inspect({{bus, idx}, {t, step}})
    if rem(t + idx, bus) == 0 do
      {t, lcm(step, bus)}
    else
      solve({bus, idx}, {t + step, step})
    end
  end

  defp lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end
end

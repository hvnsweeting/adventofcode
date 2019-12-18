defmodule Aoc2019Day7 do
  import Intcode

  def solve_part_1(text) do
    state_to_int_list(text)
    check_output(text, 0)
  end

  def thruster_signal(program, input, setting) do
    [a, b, c, d, e] = setting
    outa = check_output(program, [a, input])
    outb = check_output(program, [b, outa])
    outc = check_output(program, [c, outb])
    outd = check_output(program, [d, outc])
    oute = check_output(program, [e, outd])
  end

  def not_equal(a, b, c, d, e) do
    a != b && a != b && a != c && a != d && a != e && b != c && b != d && b != e && c != d &&
      c != e && d != e
  end

  def combination(settings) do
    for a <- settings,
        b <- settings,
        c <- settings,
        d <- settings,
        e <- settings,
        not_equal(a, b, c, d, e),
        do: [a, b, c, d, e]
  end

  def max_thruster_signal(program, input, settings) do
    combination(settings)
    |> Enum.map(fn s -> thruster_signal(program, input, s) end)
    |> Enum.max()
  end
end

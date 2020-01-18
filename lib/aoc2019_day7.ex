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
    oute
  end

  def thruster_signal_loop(program, input, setting) do
    [a, b, c, d, e] = setting
    pida = spawn(Intcode, :check_raw_output, [program, [a, input], self()])
    pidb = spawn(Intcode, :check_raw_output, [program, [b], self()])
    pidc = spawn(Intcode, :check_raw_output, [program, [c], self()])
    pidd = spawn(Intcode, :check_raw_output, [program, [d], self()])
    pide = spawn(Intcode, :check_raw_output, [program, [e], self()])

    pid2name = %{pida => :a, pidb => :b, pidc => :c, pidd => :d, pide => :e}
    name2pid = %{a: pida, b: pidb, c: pidc, d: pidd, e: pide}
    loop(pid2name, name2pid)
  end

  defp loop(pid2name, name2pid, result \\ 0) do
    receive do
      {pid, signal} ->
        IO.inspect({"master got", pid2name[pid], signal})
        src = pid2name[pid]

        case src do
          :a ->
            send(name2pid.b, {:a, signal})
            loop(pid2name, name2pid, signal)

          :b ->
            send(name2pid.c, {:b, signal})
            loop(pid2name, name2pid, signal)

          :c ->
            send(name2pid.d, {:c, signal})
            loop(pid2name, name2pid, signal)

          :d ->
            send(name2pid.e, {:d, signal})
            loop(pid2name, name2pid, signal)

          :e ->
            send(name2pid.a, {:e, signal})
            loop(pid2name, name2pid, signal)

          nil ->
            loop(pid2name, name2pid, signal)
        end

      {:finish, pid, signal} ->
        IO.inspect({pid, "Some finished"})

        if pid2name[pid] == :e do
          result
        else
          loop(pid2name, name2pid, signal)
        end
    end
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
    # |> IO.inspect(label: "settings")
    |> Enum.map(fn s -> thruster_signal(program, input, s) end)
    |> Enum.max()
  end

  def solve2(program, input, settings) do
    combination(settings)
    # |> IO.inspect(label: "settings")
    |> Enum.map(fn s ->
      thruster_signal_loop(program, input, s) |> IO.inspect(label: "a setting")
    end)
    |> Enum.max()
  end
end

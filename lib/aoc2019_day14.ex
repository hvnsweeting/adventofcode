defmodule Aoc2019Day14 do
  def build_map(reactions) do
    rs =
      reactions
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [source, target] = String.split(line, "=>", trim: true)

        sources =
          source
          |> String.split(",", trim: true)
          |> Enum.map(fn x ->
            [c, chem] = String.split(x)
            {String.to_integer(c), chem}
          end)

        [c, chem] = target |> String.split()
        {{c, chem}, sources}
      end)

    dst_src =
      rs
      |> Enum.map(fn {dst, src} ->
        {count_dest, chem_dest} = dst
        {chem_dest, {String.to_integer(count_dest), src}}
      end)
      |> Map.new()

    dst_src
  end

  def to_ore(map, {count, chem}) do
    {c, subs} = map[chem]

    times = trunc(:math.ceil(count / c))

    case subs do
      [{x, "ORE"}] ->
        {x * times, "ORE"}

      _ ->
        raise "BAD"
    end
  end

  def calculate_resource(input, {count, chem}, mul \\ 1) do
    map = build_map(input)
    # IO.inspect({chem, map})
    {c, subs} = map[chem]

    case subs do
      [{_, "ORE"}] ->
        [{mul * count, chem}]

      _ ->
        times = trunc(:math.ceil(mul * count / c))
        # IO.inspect({"TIMES", times, count, c})

        r =
          Enum.map(subs, fn {c, s} ->
            {c * times, s}
          end)

        #   calculate_resource(input, s, times)
        # end)
        # IO.inspect({"count chem", count, chem, "-->", r})
        r |> List.flatten()
    end
  end

  def count_level(map, x, lvl \\ 1) do
    {_, subs} = map[x]

    case subs do
      [{_, "ORE"}] ->
        lvl

      _ ->
        Enum.max(
          Enum.map(subs, fn {_, x} ->
            count_level(map, x, lvl + 1)
          end)
        )
    end
  end

  def transform(input, lvl, xs) do
    # TODO add lvl map, and only transform max lvl each time
    lvlmax = Enum.max(Enum.map(xs, fn {_, x} -> lvl[x] end))

    expanded =
      Enum.map(xs, fn {c, x} ->
        if lvl[x] == lvlmax do
          calculate_resource(input, {c, x}, 1)
        else
          {c, x}
        end
      end)

    expanded =
      List.flatten(expanded)
      |> Enum.group_by(fn {_, c} -> c end, fn {n, _} -> n end)
      |> Map.to_list()
      # |> IO.inspect(label: "to list")
      |> Enum.map(fn {c, xs} -> {Enum.sum(xs), c} end)

    # |> IO.inspect(label: "expanded")

    if expanded == xs do
      xs
    else
      transform(input, lvl, expanded)
    end
  end

  def to_resources(xs, map) do
    xs
    |> Enum.group_by(fn {_, c} -> c end, fn {n, _} -> n end)
    |> Map.to_list()
    # |> IO.inspect(label: "to list")
    |> Enum.map(fn {c, xs} -> {Enum.sum(xs), c} end)
    # |> IO.inspect(label: "atoms")
    |> Enum.map(fn x -> to_ore(map, x) end)
  end

  def solve1(input, find \\ {1, "FUEL"}) do
    map = build_map(input)
    # |> IO.inspect(label: "map")

    lvl =
      Map.keys(map)
      |> Enum.map(fn k ->
        {k, count_level(map, k)}
      end)
      |> Map.new()

    rs = calculate_resource(input, find)
    transform(input, lvl, rs) |> to_resources(map) |> Enum.map(fn {c, _} -> c end) |> Enum.sum()
  end

  def solve2(input) do
    map = build_map(input)

    lvl =
      Map.keys(map)
      |> Enum.map(fn k ->
        {k, count_level(map, k)}
      end)
      |> Map.new()

    per_fuel = solve1(input)
    given = 1_000_000_000_000
    start = trunc(given / per_fuel)
    find_fuel(input, map, lvl, start, per_fuel)
  end

  def find_fuel(input, map, lvl, count \\ 1, per_each \\ 0, given \\ 1_000_000_000_000) do
    # IO.inspect({"count", count})

    find = {count, "FUEL"}
    rs = calculate_resource(input, find)

    ore_count =
      transform(input, lvl, rs) |> to_resources(map) |> Enum.map(fn {c, _} -> c end) |> Enum.sum()

    if ore_count < given do
      incr = trunc((given - ore_count) / per_each)

      if incr == 0 do
        count
      else
        find_fuel(input, map, lvl, count + incr, per_each)
      end
    else
      # should never reached here as above stop cond avoids this
      count - 1
    end
  end
end

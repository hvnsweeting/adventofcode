defmodule Aoc2025.Day07 do
  use Agent

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(cache) do
    Agent.get(cache, fn state -> state end)
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.with_index()
    end)
  end

  def run_tachyon_beam([], _state, {res, count}) do
    {res |> Enum.reverse(), count}
  end

  def run_tachyon_beam([h | t], state, {res, count}) do
    row = h

    updated =
      row
      |> Enum.map(fn {c, col} ->
        cond do
          c == "." and col in state ->
            {{"|", col}, 0}

          c == "." and
              ((Enum.at(row, col + 1, :none) == {"^", col + 1} and (col + 1) in state) or
                 (Enum.at(row, col - 1, :none) == {"^", col - 1} and (col - 1) in state)) ->
            {{"|", col}, 0}

          c == "^" and col in state ->
            {{"^", col}, 1}

          c == "^" ->
            {{"^", col}, 0}

          true ->
            {{".", col}, 0}
        end
      end)

    new_state =
      updated
      |> Enum.filter(fn {{c, _}, _} -> c == "|" end)
      |> Enum.map(fn {{_, col}, _} -> col end)

    new_count =
      count +
        (updated
         |> Enum.filter(fn {_, v} -> v == 1 end)
         |> Enum.map(fn {_, v} -> v end)
         |> Enum.sum())

    run_tachyon_beam(t, new_state, {[updated | res], new_count})
  end

  def draw(ns) do
    ns
    |> Enum.map(fn {{c, _}, _} ->
      c
    end)
    |> Enum.join("")
    |> IO.puts()
  end

  def solve1(input) do
    [first | rest] =
      input
      |> parse

    index_of_start = [first |> Enum.find_index(fn {c, _} -> c == "S" end)]

    {_m, count} = run_tachyon_beam(rest, index_of_start, {[], 0})
    # m |> Enum.map(&draw/1)

    count
  end

  def solve2(input) do
    {:ok, _} = Aoc2025.Day07.start()

    [first | rest] =
      input
      |> parse

    index_of_start = first |> Enum.find_index(fn {c, _} -> c == "S" end)

    {m, _count} = run_tachyon_beam(rest, [index_of_start], {[], 0})

    # m |> Enum.map(&draw/1)

    map =
      m
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {{{c, _}, _v}, x} -> {{x, y + 1}, c} end)
      end)
      |> Enum.concat()
      |> Map.new()

    ymax = m |> Enum.count()

    r = count_tl(map, ymax, {index_of_start, 0})
    Agent.stop(__MODULE__)
    r
  end

  def count_tl(m, ymax, {x, y}) do
    cached_value = Agent.get(__MODULE__, &Map.get(&1, {x, y}))

    if cached_value do
      cached_value
    else
      if y == ymax do
        1
      else
        cond do
          m[{x, y + 1}] == "|" ->
            count_tl(m, ymax, {x, y + 1})

          m[{x, y + 1}] == "^" ->
            l = count_tl(m, ymax, {x - 1, y + 1})
            Agent.update(__MODULE__, &Map.put(&1, {x - 1, y + 1}, l))
            r = count_tl(m, ymax, {x + 1, y + 1})
            Agent.update(__MODULE__, &Map.put(&1, {x + 1, y + 1}, r))
            l + r
        end
      end
    end
  end
end

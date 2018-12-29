defmodule Day07 do
  def hello() do
    :hello
  end

  def string_to_steps(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/ ([A-Z]) /, line, capture: :all_but_first) |> Enum.concat()
    end)
    |> nexts(Map.new())
  end

  def nexts([], map) do
    map
  end

  def nexts([head | tail], map) do
    [first, second] = head

    nexts(
      tail,
      Map.merge(map, %{first => [second]}, fn _k, v1, v2 -> Enum.sort(v1 ++ v2) end)
    )
  end

  def reverse_map(map) do
    map
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      temp = v |> Enum.map(fn vi -> {vi, [k]} end) |> Map.new()

      Map.merge(acc, temp, fn _k, v1, v2 ->
        v1 ++ v2
      end)
    end)
  end

  def start_stop(map) do
    keys = Map.keys(map) |> MapSet.new()
    values = Map.values(map) |> Enum.concat() |> MapSet.new()
    start = MapSet.difference(keys, values) |> MapSet.to_list()
    stop = MapSet.difference(values, keys) |> MapSet.to_list() |> List.first()
    {start, stop}
  end

  def solve_part1(string) do
    map = string |> string_to_steps
    deps = reverse_map(map)
    {start, _} = start_stop(map)
    do_topology_sort(map, deps, start, []) |> List.to_string()
  end

  def do_topology_sort(map, deps, [h | t], result) do
    if map[h] do
      deps =
        map[h]
        |> Enum.reduce(deps, fn m, deps ->
          Map.put(deps, m, List.delete(deps[m], h))
        end)

      empties =
        deps
        |> Map.to_list()
        |> Enum.filter(fn {_, v} -> length(v) == 0 end)
        |> Enum.map(fn {k, _} -> k end)

      deps =
        deps
        |> Map.to_list()
        |> Enum.reject(fn {_, v} -> length(v) == 0 end)
        |> Map.new()

      do_topology_sort(map, deps, empties ++ t, result ++ [h])
    else
      result ++ [h]
    end
  end
end

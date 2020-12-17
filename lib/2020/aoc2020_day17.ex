defmodule Aoc2020Day17 do
  import Enum

  def read_matrix(input, d\\3) do
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> with_index
      |> map(fn {xs, y} ->
        {String.split(xs, "", trim: true)
         |> with_index, y}
      end)
      |> reduce(%{}, fn {xs, y}, acc ->
        xs
        |> reduce(acc, fn {v, x}, inacc ->
          case d do
            3 -> Map.put(inacc, {x, y, 0}, v)
            4 -> Map.put(inacc, {x, y, 0, 0}, v)
          end
        end)
      end)
  end


  def solve(config, neighbors_fn) do
    #IO.inspect({"init config", config})
    r =
      1..6
      |> reduce(config, fn n, acc ->

        acc =
          acc
          |> reduce(acc, fn {k, _v}, inneracc ->
            neighbors_fn.(k)
            #|> IO.inspect(label: "neighbor")
            |> reduce(inneracc, fn key, acc3 ->
                #IO.inspect({"in", key, acc3, key in acc3})
              if Map.has_key?(acc3, key) do
                acc3
              else
                #IO.inspect({"putting", key})
                Map.put(acc3, key, ".")
              end
            end)
            #|> IO.inspect(label: "inner")
          end)

        #IO.inspect(acc, label: "n=#{n}")
        #acc |> filter(fn {k, v} -> v == "#" end) |> IO.inspect

        acc |> map(fn {k, v} -> {k, next(acc, k, neighbors_fn)} end) |> Map.new()
      end)

    r |> count(fn {k, v} -> v == "#" end)
  end
  def solve1(input) do
    config = read_matrix(input)
    solve(config, &neighbors/1)
  end

  def next(config, key, neighbors_fn) do
    ns =
      neighbors_fn.(key)
      |> map(fn k -> Map.get(config, k, ".") end)

    #IO.inspect({"ns", ns})

    #config =
    #  if {x, y, z} in config  do
    #    config
    #  else
    #    Map.put(config, {x, y, z}, ".")
    #  end

    actives = ns |> filter(fn x -> x == "#" end) |> length
    n =
      case Map.get(config, key, ".") do
        "#" ->

          if actives == 2 || actives == 3 do
            "#"
          else
            "."
          end

        "." ->
          #IO.inspect({"active", actives})

          if actives == 3 do
            "#"
          else
            "."
          end

      end
  end

  def neighbors({x, y, z}) do
    one = [
      {x - 1, y - 1, z},
      {x, y - 1, z},
      {x + 1, y - 1, z},
      {x - 1, y, z},
      {x, y, z},
      {x + 1, y, z},
      {x - 1, y + 1, z},
      {x, y + 1, z},
      {x + 1, y + 1, z}
    ]

    two = map(one, fn {x, y, z} -> {x, y, z - 1} end)
    three = map(one, fn {x, y, z} -> {x, y, z + 1} end)
    all = one ++ two ++ three
    filter(all, fn {a, b, c} -> {a, b, c} != {x, y, z} end)
  end

  def neighbors4({x,y,z,w}) do
    one = [{x,y,z}|neighbors({x,y,z})]
    |> map(fn {x,y,z} -> {x,y,z,w} end)


    two = map(one, fn {x, y, z, w} -> {x, y, z, w-1} end)
    three = map(one, fn {x, y, z, w} -> {x, y, z, w + 1} end)
    all = one ++ two ++ three
    filter(all, fn {a, b, c,d } -> {a, b, c,d } != {x, y, z, w} end)
  end


  def solve2(input) do
    config = read_matrix(input, 4)

    solve(config, &neighbors4/1)
  end

end

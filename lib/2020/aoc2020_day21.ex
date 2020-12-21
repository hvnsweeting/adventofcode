defmodule Aoc2020Day21 do
  import Enum

  def read_input(input) do
    input
    |> String.trim()
    |> String.replace(",", "")
    |> String.split("\n", trim: true)
    |> map(fn s ->
      [ingredients, allergents] = String.split(s, "(", trim: true)

      {ingredients |> String.trim() |> String.split(" ", trim: true) |> MapSet.new(),
       allergents
       |> String.trim(")")
       |> String.replace("contains", "")
       |> String.trim()
       |> String.split(" ", trim: true)
       |> MapSet.new
      }
    end)
  end

  def solve_(input) do
    ings = read_input(input)
    ins = ings |> map(fn {i, _a} -> i end)
    |> reduce(fn x, acc -> MapSet.union(x, acc) end)

    allers = ings
    |> map(fn {_i, a} -> a end)
    |> reduce(fn x, acc -> MapSet.union(x, acc) end)

    {MapSet.size(ins), MapSet.size(allers)}
  end


  def allergen_ingeredients(foods) do
      foods
      |> map(fn {is, as} ->
        map(as, fn a ->
          filter(foods, fn {_, as2} -> a in as2 end)
          |> map(fn {is2, as2} ->

            r = if a in as2 do
              MapSet.intersection(is, is2)
            else
              MapSet.new()
            end
            {a, r}

          end)
          |> Map.new()
        end)

      end)
      |> concat
      |> uniq
      |> reduce(%{}, fn x, acc ->
        Map.merge(x, acc, fn _k, v1, v2 -> MapSet.intersection(v1, v2) end)
      end)
  end

  def solve1(input) do
    foods =
      input
      |> read_input

    allers = allergen_ingeredients(foods)

    all_ings =
      foods
      |> map(fn {is, _} -> is end)
      |> concat

    uniq_ings = MapSet.new(all_ings)


    as = allers |> Map.values() |> reduce(fn i, acc -> MapSet.union(i, acc) end)
    cannot = MapSet.difference(uniq_ings, as)

    cannot |> map(fn i -> count(all_ings, fn x -> x == i end) end) |> sum
  end

  def find_exact(allermap) do
    find_exact(allermap, [])
  end
  defp find_exact(m, result) when map_size(m) == 0 do
    result
  end
  defp find_exact(m, result) do
    ones = filter(m, fn {_k, v} -> MapSet.size(v) == 1 end)
    removed = ones
    |> map(fn {k, v} -> {k, to_list(v) |> at(0)} end)
    |> reduce(m, fn {k, v}, acc ->

      acc = Map.new(acc, fn {ki, vi} -> {ki, MapSet.delete(vi, v)} end)
      {_, acc} = Map.pop(acc, k)
      acc

    end)
    r = ones |> map(fn {k, v} -> {k, to_list(v) |> at(0)} end)
    find_exact(removed,  r ++ result)
  end

  def solve2(input) do
    foods = input |> read_input

    allergents = allergen_ingeredients(foods)
    find_exact(allergents)
    |> sort(fn {k, _v},{k2,_v2} -> k < k2 end)
    |> map(fn {_k,v} -> v end)
    |> join(",")
  end
end

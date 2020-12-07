defmodule Aoc2020Day04 do
  import Enum

  def solve1(input) do
    input
    |> String.split("\n\n")
    |> filter(fn s ->
      all?(
        map(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"], fn x ->
          String.contains?(s, x)
        end)
      )
    end)
    |> length
  end

  def solve2(input) do
    input
    |> String.split("\n\n")
    |> filter(fn s ->
      all?(
        map(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"], fn x ->
          String.contains?(s, x)
        end)
      )
    end)
    |> map(&String.split/1)
    |> map(fn xs ->
      map(
        xs,
        fn kv ->
          [k, v] = String.split(kv, ":")
          valid(k, v)
        end
      )
    end)
    |> filter(&all?/1)
    |> length
  end

  def valid("byr", year) do
    n = String.to_integer(year)
    1920 <= n && n <= 2002
  end

  def valid("iyr", year) do
    n = String.to_integer(year)
    2010 <= n && n <= 2020
  end

  def valid("eyr", year) do
    n = String.to_integer(year)
    2020 <= n && n <= 2030
  end

  def valid("hgt", value) do
    cond do
      String.ends_with?(value, "cm") ->
        v = String.trim_trailing(value, "cm")
        n = String.to_integer(v)
        150 <= n && n <= 193

      String.ends_with?(value, "in") ->
        v = String.trim_trailing(value, "in")
        n = String.to_integer(v)
        59 <= n && n <= 76

      true ->
        false
    end
  end

  def valid("hcl", value) do
    String.match?(value, ~r/^#[0-9a-f]{6}$/)
  end

  def valid("ecl", value) do
    value in String.split("amb blu brn gry grn hzl oth")
  end

  def valid("pid", value) do
    String.match?(value, ~r/^[0-9]{9}$/)
  end

  def valid("cid", _value) do
    true
  end
end

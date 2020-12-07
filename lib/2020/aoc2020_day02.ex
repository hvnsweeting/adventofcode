defmodule Aoc2020Day02 do
  def read_input_to_list_numbers(input) do
    Helper.read_input_to_list_lines(input)
  end

  def valid?(password) do
    [range, char, p] = password |> String.split()
    char = String.trim(char, ":") |> String.to_charlist() |> Enum.at(0)
    # |> IO.inspect(label: "chs")
    chs = String.to_charlist(p)

    c =
      Enum.count(chs, fn x ->
        # IO.inspect({x, char})
        x == char
      end)

    # IO.inspect({"c", c})
    # |> IO.inspect(label: "lohi")
    [low, hi] = String.split(range, "-")
    String.to_integer(low) <= c && c <= String.to_integer(hi)
  end

  def solve1(input) do
    # input = "
    # 1-3 a: abcde
    # 1-3 #b: cdefg
    # 2-9 c: ccccccccc"
    input
    |> read_input_to_list_numbers
    |> Enum.filter(&valid?/1)
    |> Enum.count()
  end

  def valid2(password) do
    [range, char, p] = password |> String.split()
    char = String.trim(char, ":") |> String.to_charlist() |> Enum.at(0)
    # |> IO.inspect(label: "chs")
    chs = String.to_charlist(p)
    # |> IO.inspect(label: "lohi")
    [low, hi] = String.split(range, "-")
    low = String.to_integer(low) - 1
    hi = String.to_integer(hi) - 1
    # IO.inspect({"c", char})
    # |> IO.inspect(label: "foo") do
    case {Enum.at(chs, low), Enum.at(chs, hi)} do
      {^char, ^char} -> false
      {^char, _} -> true
      {_, ^char} -> true
      {_, _} -> false
    end
  end

  def solve2(input) do
    input
    |> read_input_to_list_numbers
    |> Enum.filter(&valid2/1)
    |> Enum.count()
  end
end

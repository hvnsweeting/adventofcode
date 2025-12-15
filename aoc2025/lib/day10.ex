defmodule Aoc2025.Day10 do
  def parse_line(line) do
    [left, right] = line |> String.split("]")
    indicator_light_diagram = left |> String.trim("[") |> String.graphemes()
    indicator_light_diagram

    [buttons_part, rest] = right |> String.split(" {")

    buttons =
      buttons_part
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.split()
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(fn {x, _} -> x end)
      end)

    {indicator_light_diagram, buttons}
  end

  def push_buttons(lights, button) do
    button
    |> Enum.reduce(lights, fn b, acc ->
      List.update_at(acc, b, fn c ->
        cond do
          c == "." -> "#"
          c == "#" -> "."
          true -> raise "Error #{c}"
        end
      end)
    end)
  end

  def push_buttons_v2(lights, button) do
    Bitwise.bxor(lights, button)
  end

  def combinations(n, xs) do
    combinations(n - 1, xs, for(x <- xs, do: [x]))
  end

  def combinations(0, xs, acc), do: acc

  def combinations(n, xs, acc) do
    combinations(n - 1, xs, for(x <- xs, y <- acc, x not in y, do: [x | y]))
  end

  def xor_all(xs) do
    xs |> Enum.reduce(0, fn x, acc -> Bitwise.bxor(x, acc) end)
  end

  def find_buttons_v2(diagram, buttons) do
    Enum.reduce_while(1..Enum.count(buttons), 0, fn x, acc ->
      r =
        combinations(x, buttons)
        |> Enum.find(fn comb -> xor_all(comb) == diagram end)

      cond do
        r == nil -> {:cont, acc}
        true -> {:halt, Enum.count(r)}
      end
    end)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def to_bits(diagrams) do
    diagrams
    |> Enum.join()
    |> String.replace("#", "1")
    |> String.replace(".", "0")
    |> Integer.parse(2)
    |> elem(0)
  end

  def button_to_bits(diagram, button) do
    0..(Enum.count(diagram) - 1)
    |> Enum.map(fn i ->
      if i in button do
        "1"
      else
        "0"
      end
    end)
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  def solve1(input) do
    input
    |> parse
    |> Task.async_stream(
      fn {diagram, btns} ->
        # |> Enum.map(fn {diagram, btns} ->
        # IO.inspect({diagram, btns})
        find_buttons_v2(diagram |> to_bits, btns |> Enum.map(&button_to_bits(diagram, &1)))
      end,
      # |> Enum.sum
      # ,
      timeout: :infinity
    )
    |> Enum.sum_by(fn {:ok, n} -> n end)
  end
end

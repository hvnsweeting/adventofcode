defmodule Aoc2020Day12 do
  import Enum

  def solve1(input) do
    actions =input
    |> String.trim
    |> String.split("\n", trim: true)
    |> map(&(parse_line(&1)))
    |> IO.inspect


    [h|t] = actions
    move(t, {{0,0}, "E"})

    r = actions
    |> reduce({{0, 0}, "E"}, fn x, acc ->
      move([x], acc)
    end)

    IO.inspect(r)

    {{x, y}, _} = r
    abs(x)+abs(y)
  end

  @doc """
  Action N means to move north by the given value.
Action S means to move south by the given value.
Action E means to move east by the given value.
Action W means to move west by the given value.
Action L means to turn left the given number of degrees.
Action R means to turn right the given number of degrees.
  Action F means to move forward by the given value in the direction the
  """
  def parse_line("N" <> value), do: {"N", String.to_integer(value)}
  def parse_line("S" <> value), do: {"S", String.to_integer(value)}
  def parse_line("E" <> value), do: {"E", String.to_integer(value)}
  def parse_line("W" <> value), do: {"W", String.to_integer(value)}
  def parse_line("L" <> value), do: {"L", String.to_integer(value)}
  def parse_line("R" <> value), do: {"R", String.to_integer(value)}
  def parse_line("F" <> value), do: {"F", String.to_integer(value)}

  def move([], state) do
    state
  end
  def move([{"N", v} |t], {{x, y}, direction}) do
    IO.inspect("blabha")
    {{x, y-v}, direction}
  end

  def move([{"S", v} |t], {{x, y}, direction}) do
    {{x, y+v}, direction}
  end
  def move([{"W", v} |t], {{x, y}, direction}) do
    {{x-v, y}, direction}
  end
  def move([{"E", v} |t], {{x, y}, direction}) do
    {{x+v, y}, direction}
  end
  def move([{"L", v} |t], {{x, y}, direction}) do
    {{x, y}, rotate(direction, "L", v)}
  end
  def move([{"R", v} |t], {{x, y}, direction}) do
    {{x, y}, rotate(direction, "R", v)}
  end

  def move([{"F", v} |t], {{x, y}, "N"}) do
    {{x, y-v}, "N"}
  end
  def move([{"F", v} |t], {{x, y}, "S"}) do
    {{x, y+v}, "S"}
  end
  def move([{"F", v} |t], {{x, y}, "W"}) do
    {{x-v, y}, "W"}
  end
  def move([{"F", v} |t], {{x, y}, "E"}) do
    {{x+v, y}, "E"}
  end


  def rotate(c, d, degree) do
    xs = ["N", "W", "S", "E"]
    idx = find_index(xs, &(&1 == c))
    degree = trunc(degree / 90)
    case d do
      "L" ->
        r = at(xs, rem(idx + degree + 4, 4))
        IO.inspect({"rotating",c, d, degree, r})
        r
      "R" -> at(xs, rem(idx - degree + 4, 4))
    end
  end

  def solve2(input) do
    input
  end
end

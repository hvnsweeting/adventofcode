defmodule Aoc2020Day03 do
  def dup(_xs, 0, acc) do
    acc
  end

  def dup(xs, n, acc) do
    dup(xs, n - 1, acc ++ xs)
  end

  def solve1(input) do
    lines =
      input
      # input = "
      # 1-3 a: abcde
      # 1-3 #b: cdefg
      # 2-9 c: ccccccccc"
      |> Helper.read_input_to_list_lines()

    # IO.inspect(length(lines), label: "len")

    lines
    |> Enum.map(fn line -> dup(String.to_charlist(line), 323, []) end)
    # |> Enum.each(&IO.inspect/1)
    |> move(0, 0, 3, 1, 0)
  end

  def move([], _x, _y, _right, _down, count) do
    count
  end

  def move([h | t], x, y, right, down = 2, count) do
    # c = Enum.slice(h, x, x+right+1)|> IO.inspect |> Enum.count(fn x -> x == ?# end)
    # |> IO.inspect()
    check = Enum.slice(h, x, x + right + 1)

    if check == [] do
      count
    else
      [f | _] = check
      # IO.inspect({check, f, count})
      t = Enum.drop(t, 1)

      if f == ?# do
        move(t, x + right, y + down, right, down, count + 1)
      else
        move(t, x + right, y + down, right, down, count)
      end
    end
  end

  def move([h | t], x, y, right, down, count) do
    # c = Enum.slice(h, x, x+right+1)|> IO.inspect |> Enum.count(fn x -> x == ?# end)
    # |> IO.inspect()
    check = Enum.slice(h, x, x + right + 1)

    if check == [] do
      count
    else
      [f | _] = check
      # IO.inspect({check, f, count})

      if f == ?# do
        move(t, x + right, y + down, right, down, count + 1)
      else
        move(t, x + right, y + down, right, down, count)
      end
    end
  end

  def solve2(input) do
    lines =
      input
      # input = "
      # 1-3 a: abcde
      # 1-3 #b: cdefg
      # 2-9 c: ccccccccc"
      |> Helper.read_input_to_list_lines()
      |> Enum.map(fn line -> dup(String.to_charlist(line), 323, []) end)

    # |> Enum.each(&IO.inspect/1)
    a = lines |> move(0, 0, 1, 1, 0)
    b = lines |> move(0, 0, 3, 1, 0)
    c = lines |> move(0, 0, 5, 1, 0)
    d = lines |> move(0, 0, 7, 1, 0)
    e = lines |> move(0, 0, 1, 2, 0)

    a * b * c * d * e
  end
end

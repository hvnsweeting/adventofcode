defmodule Aoc2025.Day06 do
  def parse(input) do
    [operators | operands] =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split(" ", trim: true)
      end)
      |> Enum.reverse()

    {operands |> Enum.reverse() |> Enum.map(fn ns -> Enum.map(ns, &to_number/1) end), operators}
  end

  def to_number(n) do
    {ni, ""} = Integer.parse(n)
    ni
  end

  def solve1(input) do
    {operands, ops} =
      input
      |> parse

    operands
    |> Enum.zip()
    |> Enum.zip(ops)
    |> Enum.map(&calculate/1)
    |> Enum.sum()
  end

  def calculate({ns, op}) do
    ns = Tuple.to_list(ns)

    if op == "*" do
      Enum.reduce(ns, 1, &*/2)
    else
      Enum.sum(ns)
    end
  end

  def parse2(input) do
    [operators | operands] =
      input
      |> String.split("\n", trim: true)
      |> Enum.reverse()

    ops =
      operators
      |> String.reverse()
      |> split_keep_spaces([], [])

    operands_charlist =
      operands
      |> Enum.map(&String.to_charlist/1)

    operands = parse2_operands(ops, operands_charlist, [])

    Enum.zip(operands, ops |> Enum.reverse())
    |> Enum.map(&celphalopod_calculate/1)
  end

  def celphalopod_calculate({operands, ops}) do
    oprs =
      Enum.zip(operands)
      |> Enum.map(fn x ->
        x |> Tuple.to_list() |> Enum.reverse() |> to_string |> String.trim()

        # |> Integer.parse
      end)
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.map(fn i -> Integer.parse(i) |> elem(0) end)
      |> List.to_tuple()

    {oprs, ops |> to_string |> String.trim()}
  end

  def parse2_operands([], _operands, res) do
    res
  end

  def parse2_operands([h | t], operands, res) do
    # get length of each operand, then take the same length from each line
    len = Enum.count(h)

    problem =
      operands
      |> Enum.map(fn line ->
        Enum.take(line, len)
      end)

    parse2_operands(
      t,
      Enum.map(
        operands,
        fn line ->
          Enum.drop(line, len)
        end
      ),
      [problem | res]
    )
  end

  def split_keep_spaces(<<h, t::binary>>, tmp, res) do
    # IO.inspect(h, label: "head")
    if h == 32 do
      split_keep_spaces(t, [h | tmp], res)
    else
      split_keep_spaces(t, [], [[h | tmp] | res])
    end
  end

  def split_keep_spaces("", _tmp, res) do
    res
  end

  def solve2(input) do
    input
    |> parse2
    # |> IO.inspect
    |> Enum.map(&calculate/1)
    |> Enum.sum()
  end
end

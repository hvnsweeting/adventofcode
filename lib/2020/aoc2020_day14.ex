defmodule Aoc2020Day14 do
  import Enum

  def solve1(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> map(&parse(&1))
    |> reduce({[], %{}}, &reducer/2)
    |> elem(1)
    |> Map.values()
    |> sum
  end

  def solve2(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> map(&parse(&1))
    |> reduce({[], %{}}, &reducer2/2)
    |> elem(1)
    |> Map.values()
    |> sum
  end

  defp combination(bits, []) do
    s = bits |> join("")
    {dec, _} = Integer.parse(s, 2)
    dec
  end

  defp combination(bits, [x | xs]) do
    {_v, idx} = x

    [
      combination(List.replace_at(bits, idx, "0"), xs),
      combination(List.replace_at(bits, idx, "1"), xs)
    ]
  end

  defp reducer2({:mask, mask}, {_omask, omem}) do
    {mask, omem}
  end

  defp reducer2({idx, value}, {omask, omem}) do
    vr = binary(idx) |> reverse
    omar = omask |> reverse

    newv =
      zip(omar, vr)
      |> map(fn {x, y} ->
        cond do
          x == "0" -> y
          true -> x
        end
      end)

    r = reverse(newv)
    # IO.inspect({idx, value, r})

    xs =
      r
      |> with_index
      |> filter(fn {v, _idx} ->
        v == "X"
      end)

    # IO.inspect(xs)

    v =
      combination(r, xs)
      |> List.flatten()

    r =
      v
      |> reduce(omem, fn x, acc ->
        Map.put(acc, x, value)
      end)

    {omask, r}
  end

  defp reducer({:mask, mask}, {_omask, omem}) do
    {mask, omem}
  end

  defp reducer({idx, value}, {omask, omem}) do
    vr = binary(value) |> reverse
    omar = omask |> reverse

    newv =
      zip(omar, vr)
      |> map(fn {x, y} ->
        cond do
          x == "X" -> y
          true -> x
        end
      end)

    s = reverse(newv) |> join("")

    s =
      if s == "" do
        "0"
      else
        s
      end

    {dec, _} = Integer.parse(s, 2)

    {omask, Map.put(omem, idx, dec)}
  end

  defp binary(n) do
    binary(n, [])
  end

  defp pad(xs) when length(xs) < 36 do
    pad(["0" | xs])
  end

  defp pad(xs) do
    xs
  end

  defp binary(0, acc) do
    acc
    |> map(&Integer.to_string/1)
    |> pad
  end

  defp binary(n, acc) do
    binary(div(n, 2), [rem(n, 2) | acc])
  end

  def parse("mask =" <> mask) do
    {:mask, String.split(mask |> String.trim(), "", trim: true)}
  end

  def parse(line) do
    matched = Regex.named_captures(~r/mem\[(?<idx>[0-9]+)\] = (?<value>.*)/, line)
    {String.to_integer(matched["idx"]), String.to_integer(matched["value"])}
  end
end

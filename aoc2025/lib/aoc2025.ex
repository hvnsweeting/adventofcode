defmodule Aoc2025 do
  @moduledoc """
  Documentation for `Aoc2025`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2025.hello()
      :world

  """

  def is_invalid?(id) do
    n = String.length(id)
    half = div(n, 2)

    if rem(n, 2) == 0 do
      String.slice(id, 0, half) == String.slice(id, half, n + 1)
    else
      false
    end
  end

  def is_invalid_v2?(id) do
    n = String.length(id)

    ## BE CAREFUL, ELIXIR ALLOW 10..1 WITH AUTO step -1
    possibles =
      2..n//1
      |> Enum.map(fn i ->
        String.slice(id, 0, div(n, i))
        |> String.duplicate(i)
      end)

    id in possibles
  end

  def invalid_in_range(range, invalid? \\ &is_invalid?/1) do
    [start_str, end_str] = String.split(range, "-")
    {startr, ""} = Integer.parse(start_str)
    {endr, ""} = Integer.parse(end_str)

    startr..endr
    |> Enum.filter(fn x -> invalid?.(to_string(x)) end)
  end

  def solve(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line -> invalid_in_range(line) end)
    |> Enum.concat()
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line -> invalid_in_range(line, &is_invalid_v2?/1) end)
    |> Enum.concat()
    |> Enum.sum()
  end
end

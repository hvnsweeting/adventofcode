defmodule Adventofcode do
  @moduledoc """
  Documentation for Adventofcode.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Adventofcode.hello()
      :world

  """
  def claim_to_set(claim) do
    [left_top, wide_tall] =
      String.split(claim, "@") |> Enum.at(1) |> String.split(":", trim: true)

    [left, top] =
      String.split(left_top, ",", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    [wide, tall] =
      String.split(wide_tall, "x", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    MapSet.new(for x <- left..(left + wide - 1), y <- top..(top + tall - 1), do: {x, y})
  end

  def compare_one_claim_to_the_rest(_, []) do
    MapSet.new()
  end

  def compare_one_claim_to_the_rest(one, [h | t]) do
    MapSet.union(
      MapSet.intersection(one, h),
      compare_one_claim_to_the_rest(one, t)
    )
  end

  def compare_all([]) do
    MapSet.new()
  end

  def compare_all([h | t]) do
    MapSet.union(
      compare_one_claim_to_the_rest(h, t),
      compare_all(t)
    )
  end

  def overlap_claim_count(one, list) do
    one = claim_to_set(one)
    list = Enum.map(list, &claim_to_set/1)
    overlap(one, list)
  end

  def overlap(_, []) do
    0
  end

  def overlap(one, [h | t]) do
    if MapSet.intersection(one, h) != MapSet.new() do
      1 + overlap(one, t)
    else
      overlap(one, t)
    end
  end

  def find_claim_does_not_overlap(claims) do
    # only overlap with itself, thus == 1
    Enum.find(claims, fn x -> overlap_claim_count(x, claims) == 1 end)
  end

  def square_inches_overlap(claims) do
    claims_set = claims |> Enum.map(&claim_to_set/1)
    compare_all(claims_set) |> Enum.count()
  end

  def hello do
    :world
  end
end

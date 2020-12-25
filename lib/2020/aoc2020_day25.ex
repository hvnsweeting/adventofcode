defmodule Aoc2020Day25 do
  import Enum

  def find_loop(subject, loopsize, value, target) when value == target do
    loopsize
  end

  def find_loop(subject, loopsize, value, target) do
    value = value * subject
    value = rem(value, 20_201_227)
    find_loop(subject, loopsize + 1, value, target)
  end

  def transform(subject, 0, value) do
    value
  end

  def transform(subject, loopsize, value) do
    value = value * subject
    value = rem(value, 20_201_227)
    transform(subject, loopsize - 1, value)
  end

  def solve1(input) do
    [card_pub_key, door_pub_key] =
      input
      |> read_input

    card_loop_size = find_loop(7, 0, 1, card_pub_key)
    door_loop_size = find_loop(7, 0, 1, door_pub_key)
    # {card_loop_size, door_loop_size}

    encryption_key = transform(door_pub_key, card_loop_size, 1)
  end

  def read_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> map(&String.to_integer/1)
  end
end

defmodule Aoc2020Day22 do
  import Enum

  defp read_input(input) do
    [p1, p2] =
      input
      |> String.trim()
      |> String.split("\n\n", trim: true)

    {parse_hand(p1), parse_hand(p2)}
  end

  def parse_hand(hand) do
    hand
    |> String.split(":")
    |> Enum.at(1)
    |> String.split("\n", trim: true)
    |> map(&String.to_integer(&1))
  end

  def play([], hand2) do
    hand2
  end

  def play(hand1, []) do
    hand1
  end

  def play([h1 | t1], [h2 | t2]) when h1 > h2 do
    # IO.inspect({h1, t1, h2, t2})
    play(t1 ++ [h1, h2], t2)
  end

  def play([h1 | t1], [h2 | t2]) when h1 < h2 do
    play(t1, t2 ++ [h2, h1])
  end

  def solve1(input) do
    {h1, h2} =
      input
      |> read_input

    play(h1, h2)
    |> reverse
    |> with_index
    |> reduce(0, fn {c, i}, sum ->
      sum + c * (i + 1)
    end)
  end

  def play2(_configs, [], hand2) do
    {:p2, hand2}
  end

  def play2(_configs, hand1, []) do
    {:p1, hand1}
  end

  def play2(configs, [h1 | t1] = c1, [h2 | t2] = c2) do
    cond do
      member?(configs.p1, c1) && member?(configs.p2, c2) ->
        # IO.inspect({"Instant win", configs})
        {:p1, c1}

      true ->
        # IO.inspect({h1, t1, h2, t2})

        cond do
          h1 <= length(t1) && h2 <= length(t2) ->
            # IO.inspect({"playing subgame", h1, t1, h2, t2})
            {w, _} = play2(%{p1: [], p2: []}, take(t1, h1), take(t2, h2))
            # IO.inspect({"winner", w})

            case w do
              :p1 -> play2(updateconfig(configs, c1, c2), t1 ++ [h1, h2], t2)
              :p2 -> play2(updateconfig(configs, c1, c2), t1, t2 ++ [h2, h1])
            end

          h1 > h2 ->
            play2(updateconfig(configs, c1, c2), t1 ++ [h1, h2], t2)

          h1 < h2 ->
            play2(updateconfig(configs, c1, c2), t1, t2 ++ [h2, h1])

          true ->
            raise "NOT HERE"
        end
    end
  end

  def updateconfig(configs, c1, c2) do
    Map.update!(configs, :p1, fn old -> [c1 | old] end)
    |> Map.update!(:p2, fn old -> [c2 | old] end)
  end

  def solve2(input) do
    {h1, h2} =
      input
      |> read_input

    configs = %{p1: [], p2: []}

    {_winner, cards} = play2(configs, h1, h2)

    cards
    # |> IO.inspect()
    |> reverse
    |> with_index
    |> reduce(0, fn {c, i}, sum ->
      sum + c * (i + 1)
    end)
  end
end

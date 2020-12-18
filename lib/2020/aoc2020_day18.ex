defmodule Aoc2020Day18 do
  import Enum

  @doc """
  To make + and * has same precedence, override them with <<< and >>> which
  are have same precedence.
  https://hexdocs.pm/elixir/master/operators.html#custom-and-overridden-operators
  """
  def solve1(input) do
    list =
      "[" <>
        (input
         |> String.trim()
         |> String.replace("+", ">>>")
         |> String.replace("*", "<<<")
         |> String.split("\n", trim: true)
         |> join(",\n")) <> "]"

    tpl = ~s"""
    defmodule MyOperators do
      def a >>> b, do: a + b
      def a <<< b, do: a * b
    end

    defmodule Aoc2020Day18Hack do
      import MyOperators
      def run() do
        Enum.sum(#{list})
          end
        end
    Aoc2020Day18Hack.run()
    """

    {r, _binding} = Code.eval_string(tpl)
    r
  end

  @doc """
  Override only *, make + has higher precedence.
  """
  def solve2(input) do
    list =
      "[" <>
        (input
         |> String.trim()
         |> String.replace("*", "<<<")
         |> String.split("\n", trim: true)
         |> join(",\n")) <> "]"

    tpl = ~s"""
    defmodule MyOperators do
      def a <<< b, do: a * b
    end

    defmodule Aoc2020Day18Hack do
      import MyOperators
      def run() do
        Enum.sum(#{list})
          end
        end
    Aoc2020Day18Hack.run()
    """

    {r, _binding} = Code.eval_string(tpl)
    r
  end
end

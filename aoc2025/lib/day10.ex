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
   button |> Enum.reduce(lights, fn b, acc ->
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

  def find_buttons(diagram, [], state, res) do
    10000
  end
  def find_buttons(diagram, buttons, state, res) do
    # IO.inspect({diagram, buttons, state, res}) 
    if state == diagram do
      # IO.inspect(diagram |> Integer.to_string(2))
    IO.inspect({diagram, buttons, state, res}) 
      #IO.inspect({diagram|>Enum.join, res|>Enum.count}, label: "rest") 
      res |> Enum.count()
    else
      buttons
      |> Enum.map(fn b ->
        # new = push_buttons(state, b)
        new = push_buttons_v2(state, b)
        notb =  for i <- buttons, i != b , do: i
       find_buttons(diagram, notb, new, [b | res])
      end)
      |> Enum.min(&<=/2, fn -> 0 end)
    end
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def to_bits(diagrams) do
    diagrams |> Enum.join()
    |> String.replace("#", "0")
    |> String.replace(".", "1")
    |> Integer.parse(2)
    |> elem(0)
  end

  def button_to_bits(diagram, button) do
    0..(Enum.count(diagram) - 1)
    |> Enum.map(fn i -> if i in button do "1" else "0" end end)
    |> Enum.join
    |> Integer.parse(2)
    |> elem(0)

  end
  def solve1(input) do

    input
    |> parse
    # |> Task.async_stream(fn {diagram, btns} ->
    |> Enum.map(fn {diagram, btns} ->
      find_buttons(diagram|> to_bits, btns|> Enum.map(&button_to_bits(diagram,&1)), diagram |> Enum.map(fn _ -> "." end) |> to_bits, [])
    end)
    # |> Enum.sum
    #,
    # timeout: :infinity)
    # |> Enum.sum_by(fn {:ok, n} -> n end)

    
    # input
    # |> parse
    # |> Enum.map(fn {d, btns} ->
    #    {Enum.count(btns), fact(Enum.count(btns))} end)
    # |> IO.inspect
    # |> Enum.map(fn {_, a} -> a end)
    # |> Enum.sum
  end

  def fact(n) do
    (1..(n)) |> Enum.reduce(1, fn x,acc -> x * acc end)


    end
end

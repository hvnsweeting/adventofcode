defmodule Aoc2019Day11 do
  @up 0
  @left 1
  @down 2
  @right 3
  @black 0
  @white 1
  def turn_left(current_direction) do
    rem(current_direction + 1, 4)
  end

  def turn_right(current_direction) do
    rem(current_direction + 4 - 1, 4)
  end

  def draw(panels) do
    panel_list = panels |> Map.to_list()
    xs = panel_list |> Enum.map(fn {{x, _}, _} -> x end)
    ys = panel_list |> Enum.map(fn {{_, y}, _} -> y end)
    {minx, maxx, miny, maxy} = {Enum.min(xs), Enum.max(xs), Enum.min(ys), Enum.max(ys)}

    miny..maxy
    |> Enum.map(fn y ->
      minx..maxx
      |> Enum.map(fn x ->
        case Map.fetch(panels, {x, y}) do
          {:ok, color} ->
            if(color == @white, do: "#", else: ".")

          :error ->
            "."
        end
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
  end

  def loop(child, panels, x, y, current_direction) do
    receive do
      {:finish, _} ->
        panels

      {:day11, color_to_paint, direction} ->
        new_direction =
          if direction == 0 do
            turn_left(current_direction)
          else
            turn_right(current_direction)
          end

        {newx, newy} =
          case new_direction do
            @up ->
              {x, y - 1}

            @left ->
              {x - 1, y}

            @down ->
              {x, y + 1}

            @right ->
              {x + 1, y}
          end

        panels = Map.put(panels, {x, y}, color_to_paint)

        # turn = if direction == 0 do
        #  "left"
        # else
        #  "right"
        # end
        # IO.inspect({"Program outputed", {"color",color_to_paint, "turn", direction}})
        # if color_to_paint == @black do
        #   IO.inspect({"at", {x, y}, "color to pain black", "turn", turn, panels})
        # else
        #   IO.inspect({"at", {x, y}, "color to pain white", "turn", turn, panels})
        # end

        # check new x y in board or not and its color
        # send to robot
        case Map.fetch(panels, {newx, newy}) do
          {:ok, color} ->
            send(child, {:color, color})

          :error ->
            send(child, {:color, @black})
        end

        loop(child, panels, newx, newy, new_direction)
    end
  end

  def solve1(program) do
    program
    |> String.trim()

    pid = spawn(Intcode, :check_raw_output, [program, [0], self()])
    panels = loop(pid, Map.new(), 0, 0, @up)
    panels |> Map.to_list() |> length
  end

  def solve2(program) do
    program
    |> String.trim()

    pid = spawn(Intcode, :check_raw_output, [program, [1], self()])
    panels = loop(pid, Map.new(), 0, 0, @up)
    panels |> draw
  end
end

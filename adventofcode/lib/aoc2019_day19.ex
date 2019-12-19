defmodule Aoc2019Day19 do
  def find_square(input, x, y, under \\ true, minx \\ 0, size \\ 99) do
    good_xy = input |> Intcode.check_output([x, y]) == 1
    # if good_xy do
    #   IO.inspect({x,y})
    # end
    found =
      good_xy && input |> Intcode.check_output([x + size, y]) == 1 &&
        input |> Intcode.check_output([x, y + size]) == 1 &&
        input |> Intcode.check_output([x + size, y + size]) == 1

    if found do
      {x, y, x * 10_000 + y}
    else
      if good_xy do
        if under == true do
          find_square(input, x + 1, y, false, x)
        else
          # optimization:
          # first time meet 1 in new row, thus save it as minx,
          # coz next line would use x >= minx, not <
          find_square(input, x + 1, y, false, minx)
        end
      else
        # under or over
        if under do
          if y < 4 do
            # by picture output we know there is no 1 for line y = 1 2 3
            # IO.inspect({"Advance y new row", 0, y+1, true})
            find_square(input, 0, y + 1, true, minx)
          else
            # IO.inspect({"Advance x", x+1, y, true})
            find_square(input, x + 1, y, true, minx)
          end
        else
          # IO.inspect({"Advance y new row", minx, y+1, true})
          find_square(input, minx, y + 1, true, minx)
        end
      end
    end
  end

  def draw(input) do
    r = for x <- 0..49, y <- 0..49, do: Intcode.check_output(input, [x, y])
    r |> Enum.chunk_every(100) |> IO.inspect()
  end

  def affected(input, x, y) do
    Intcode.check_output(input, [x, y]) == 1
  end

  def solve1(input) do
    for(x <- 0..49, y <- 0..49, affected(input, x, y), do: 1) |> Enum.sum()
  end

  def solve2(input) do
    {_, _, result} = find_square(input, 0, 0)
    result
  end
end

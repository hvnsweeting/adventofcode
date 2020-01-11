defmodule Aoc2019Day13Test do
  use ExUnit.Case

  @empty_tile 0
  @wall_tile 1
  @block_tile 2
  @paddle_tile 3
  @ball_tile 4
  @tilt_to_right 1
  @tilt_to_left -1
  @neutral_position 0
  defp draw_tile({_, _}, @empty_tile) do
    " "
  end

  defp draw_tile({_, _}, @wall_tile) do
    "#"
  end

  defp draw_tile({_, _}, @block_tile) do
    "x"
  end

  defp draw_tile({_, _}, @paddle_tile) do
    "="
  end

  defp draw_tile({_, _}, @ball_tile) do
    "o"
  end

  def draw(tmap) do
    tiles = tmap |> Map.to_list()
    blocks = tiles |> Enum.filter(fn {{_, _}, i} -> i == 2 end) |> length
    # IO.inspect({"Blocks #", blocks})
    xmax = tiles |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.max()
    ymax = tiles |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.max()

    1..ymax
    |> Enum.map(fn y ->
      1..xmax
      |> Enum.map(fn x ->
        if Map.has_key?(tmap, {x, y}) do
          draw_tile({x, y}, tmap[{x, y}])
        else
          " "
        end
      end)
      |> Enum.join("")
    end)
    |> Enum.each(fn line -> IO.puts(line) end)

    # for CLI game screen 
    Process.sleep(1)

    # clear screen
    IO.puts("\e[H\e[2J")
  end

  def solve1(program) do
    program = program |> String.trim()

    out = Intcode.check_raw_output(program, [])

    tiles = out |> Enum.chunk_every(3)
    tmap = tiles |> Enum.map(fn [x, y, i] -> {{x, y}, i} end) |> Map.new()
    tmap |> draw

    tiles = out |> Enum.chunk_every(3)
    blocks = tiles |> Enum.filter(fn [_, _, i] -> i == 2 end) |> length
    blocks
  end

  def loop(child, game, last_paddle, last_ball, start \\ false, sentcmd \\ false) do
    # IO.inspect({"paddle", last_paddle, "ball", last_ball, "start", start, "sent", sentcmd})
    start = Map.has_key?(game, {34, 20})

    receive do
      {:day13, x, y, z} ->
        # IO.inspect({"out", x,y,z})
        game = Map.put(game, {x, y}, z)
        # IO.inspect({"master got output", x, y, z, start})

        if {x, y, z} == {34, 20, 1} do
          IO.inspect({"************************************************************START"})
          send(child, {:day13, 0})
        end

        # draw(game)

        last_paddle =
          if z == @paddle_tile do
            {x, y}
          else
            last_paddle
          end

        {xpad, _} = last_paddle

        old_last_ball = last_ball

        last_ball =
          if z == @ball_tile do
            {x, y}
          else
            last_ball
          end

        if z == @ball_tile do
          {oldballx, oldbally} = old_last_ball
          # ball moving down
          if y > oldbally do
            landx =
              if oldballx < x do
                # ball moving right
                landx = x + (18 - y)
              else
                landx = x - (18 - y)
              end

            # IO.inspect({"Planning landing at x", landx})

            if !start do
              #            send(child, {:day13, @neutral_position})
              loop(child, game, last_paddle, last_ball, start, sentcmd)
            else
              # IO.inspect({"Sent control ", "foo"})

              cond do
                xpad > landx ->
                  send(child, {:day13, @tilt_to_left})

                xpad == landx ->
                  send(child, {:day13, @neutral_position})

                xpad < landx ->
                  send(child, {:day13, @tilt_to_right})
              end

              loop(child, game, last_paddle, last_ball, start, false)
            end
          else
            {xpad, ypad} = last_paddle
            # IO.inspect("Send for up")

            cond do
              xpad < x ->
                send(child, {:day13, @tilt_to_right})

              xpad == x ->
                send(child, {:day13, @neutral_position})

              xpad > x ->
                send(child, {:day13, @tilt_to_left})
            end

            loop(child, game, last_paddle, last_ball, start, false)
          end
        else
          loop(child, game, last_paddle, last_ball, start, sentcmd)
        end

      {:day13, score} ->
        IO.inspect({"**********============score", score})
        loop(child, game, last_paddle, last_ball, start)

      e ->
        IO.inspect({"ERROR", e})
        raise "error"
    end
  end

  def solve2(program) do
    program = program |> String.trim()
    p = program |> String.replace("1", "2", global: false)

    {:ok, child} = Task.start(Intcode, :check_raw_output, [p, [], self()])
    last_paddle = {-1, -1}
    last_ball = {-1, -1}
    loop(child, Map.new(), last_paddle, last_ball)
    # |> draw
  end

  # test "solve1" do
  #   {:ok, input} = File.read("test/input2019_13.txt")
  #   assert solve1(input) == 216
  # end

  test "solve2" do
    {:ok, input} = File.read("test/input2019_13.txt")
    assert solve2(input) == 10000
    # assert Aoc2019Day.solve1(input) == nil
  end
end

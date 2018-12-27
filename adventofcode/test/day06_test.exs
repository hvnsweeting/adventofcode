defmodule Day06Test do
  use ExUnit.Case
  doctest Day06
  @example "1, 1
1, 6
8, 3
3, 4
5, 5
8, 9"

  test "greets the world" do
    assert Day06.hello() == :hello
  end

  test "smallest grid" do
    coord =
      @example
      |> Day06.string_to_coordinate()
      |> Day06.smallest_grid()

    assert coord == {{1, 1}, {8, 9}}
  end

  test "Manhattan distance of {1,1} {3,4} is 5" do
    [first, forth] = Day06.string_to_coordinate("1, 1\n3, 4")

    assert Day06.manhattan_distance(
             first,
             forth
           ) == 5
  end

  test "boundary" do
    assert @example |> Day06.string_to_coordinate() |> Day06.boundery_indexes() == [
             true,
             true,
             true,
             false,
             false,
             true
           ]
  end

  test "generate grid" do
    assert @example
           |> Day06.string_to_coordinate()
           |> Day06.smallest_grid()
           |> Day06.generate_grid_coords()
           |> length == 72
  end

  test "solve_example" do
    assert @example |> Day06.solve_part1() == 17
  end

  test "part 2 example" do
    assert @example |> Day06.solve_part2(32) == 16
  end

  test "total distance of 4,3 to all points is 30" do
    assert @example
           |> Day06.string_to_coordinate()
           |> Day06.total_distance({4, 3}) == 30
  end
end

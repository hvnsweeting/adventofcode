defmodule Day06 do
  def hello() do
    :hello
  end

  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def string_to_coordinate(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn s -> String.split(s, ", ") end)
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
  end

  def smallest_grid(coordinates) do
    {min_x, _} = coordinates |> Enum.min_by(fn {x, _} -> x end)
    {_, min_y} = coordinates |> Enum.min_by(fn {_, y} -> y end)
    {max_x, _} = coordinates |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = coordinates |> Enum.max_by(fn {_, y} -> y end)
    {{min_x, min_y}, {max_x, max_y}}
  end

  def boundery?({x, y}, max_min) do
    {{min_x, min_y}, {max_x, max_y}} = max_min
    x == min_x || x == max_x || (y == min_y || y == max_y)
  end

  def boundery_indexes(coordinates) do
    {{min_x, min_y}, {max_x, max_y}} = smallest_grid(coordinates)

    coordinates
    |> Enum.map(
      &boundery?(
        &1,
        {{min_x, min_y}, {max_x, max_y}}
      )
    )
  end

  def generate_grid_coords({top_left, bottom_right}) do
    {top_left_x, top_left_y} = top_left
    {bottom_right_x, bottom_right_y} = bottom_right
    for x <- top_left_x..bottom_right_x, y <- top_left_y..bottom_right_y, do: {x, y}
  end

  def solve_part1(input) do
    coords = input |> string_to_coordinate
    max_min = smallest_grid(coords)

    boundary = coords |> boundery_indexes

    grid_coords =
      smallest_grid(coords)
      |> IO.inspect()
      |> generate_grid_coords

    coords_closest_index =
      grid_coords
      |> Enum.map(fn {x, y} ->
        {{x, y}, for(c <- coords, do: manhattan_distance(c, {x, y}))}
      end)
      |> Enum.filter(fn {_, v} ->
        Enum.filter(v, &(&1 == Enum.min(v))) |> length == 1
      end)
      |> Enum.map(fn {coord, distances} ->
        {coord, Enum.find_index(distances, &(&1 == Enum.min(distances)))}
      end)

    # those have points on edge of grid closest to it
    index_of_input_points_that_has_infinite_area =
      coords_closest_index
      |> Enum.map(fn {{x, y}, index} -> if boundery?({x, y}, max_min), do: index, else: nil end)
      |> Enum.reject(fn x -> x == nil end)
      |> Enum.uniq()
      |> IO.inspect()

    coords_closest_index
    |> Enum.group_by(fn {_, nearest_index} -> nearest_index end)
    |> Enum.map(fn {index, nearest_coords} -> {index, length(nearest_coords)} end)
    |> Enum.reject(fn {idx, count} ->
      Enum.member?(index_of_input_points_that_has_infinite_area, idx)
    end)
    |> Enum.max_by(fn {_k, v} -> v end)
    |> elem(1)
  end
end

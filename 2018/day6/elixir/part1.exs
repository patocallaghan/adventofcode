# https://adventofcode.com/2018/day/6

defmodule ChronalCoordinates do
  def answer(raw_coordinates) do
    coordinates =
      raw_coordinates
      |> Enum.map(&process_raw_coordinate/1)

    grid_size = coordinates |> find_grid_size

    coordinates
    |> generate_distances_on_grid(grid_size)
    |> IO.inspect()
    |> count_frequencies(grid_size)
    |> IO.inspect()
    |> find_max_frequency
  end

  def process_raw_coordinate(coordinate) do
    [x, y] = String.split(coordinate, ", ")
    {String.to_integer(x), String.to_integer(y)}
  end

  def generate_distances_on_grid(coordinates, {min_x, min_y, max_x, max_y}) do
    Enum.reduce(min_x..max_x, %{}, fn x, acc ->
      Enum.reduce(min_y..max_y, acc, fn y, acc ->
        process_coordinates_for_grid_point(x, y, coordinates, acc)
      end)
    end)
  end

  defp process_coordinates_for_grid_point(grid_x, grid_y, coordinates, acc) do
    Enum.reduce(coordinates, acc, fn {x_coord, y_coord}, acc ->
      new_distance = taxicab_distance(grid_x, grid_y, x_coord, y_coord)

      Map.update(
        acc,
        {grid_x, grid_y},
        {new_distance, [{x_coord, y_coord}]},
        fn {current_distance, stored_coords} ->
          update_coordinates(new_distance, current_distance, {x_coord, y_coord}, stored_coords)
        end
      )
    end)
  end

  defp update_coordinates(new_distance, current_distance, coords, _stored_coords)
       when new_distance < current_distance do
    {new_distance, [coords]}
  end

  defp update_coordinates(new_distance, current_distance, coords, stored_coords)
       when new_distance == current_distance do
    {current_distance, [coords | stored_coords]}
  end

  defp update_coordinates(_new_distance, current_distance, _coords, stored_coords) do
    {current_distance, stored_coords}
  end

  def find_grid_size(coordinates) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coordinates, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coordinates, fn {_, y} -> y end)
    {min_x, min_y, max_x, max_y}
  end

  defp count_frequencies(grid_calculations, grid_size) do
    Map.to_list(grid_calculations)
    |> Enum.reduce(%{}, fn current, acc -> process_coordinate(current, acc, grid_size) end)
  end

  defp find_max_frequency(frequency_counts) do
    {_, max_frequency} =
      frequency_counts
      |> Map.to_list()
      |> Enum.max_by(fn {_, count} -> count end)

    max_frequency
  end

  defp process_coordinate({_, {_, [{x, _}]}}, map, {min_x, _, _, _})
       when x == min_x do
    map
  end

  defp process_coordinate({_, {_, [{x, _}]}}, map, {_, _, max_x, _})
       when x == max_x do
    map
  end

  defp process_coordinate({_, {_, [{_, y}]}}, map, {_, min_y, _, _})
       when y == min_y do
    map
  end

  defp process_coordinate({_, {_, [{_, y}]}}, map, {_, _, _, max_y})
       when y == max_y do
    map
  end

  defp process_coordinate({_grid_coords, {_count, [coords]}}, map, _grid_size) do
    Map.update(map, coords, 1, &(&1 + 1))
  end

  defp process_coordinate({_grid_coords, {_count, [_head | _tail]}}, map, _grid_size) do
    map
  end

  defp taxicab_distance(x1, y1, x2, y2) do
    abs(y1 - y2) + abs(x1 - x2)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule ChronalCoordinatesTest do
      use ExUnit.Case

      import ChronalCoordinates

      test "part 1" do
        assert answer([
                 "1, 1",
                 "1, 6",
                 "8, 3",
                 "3, 4",
                 "5, 5",
                 "8, 9"
               ]) == 17
      end
    end

  [input_file] ->
    File.read!(input_file)
    |> String.split("\n", trim: true)
    |> ChronalCoordinates.answer()
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

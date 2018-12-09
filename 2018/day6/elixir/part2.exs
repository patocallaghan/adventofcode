# https://adventofcode.com/2018/day/6
defmodule ChronalCoordinates do
  def answer(raw_coordinates, threshold) do
    coordinates =
      raw_coordinates
      |> Enum.map(&process_raw_coordinate/1)

    grid_size = coordinates |> find_grid_size

    coordinates
    |> generate_total_distances_on_grid(grid_size)
    |> IO.inspect()
    |> find_region_size(threshold)
  end

  def process_raw_coordinate(coordinate) do
    [x, y] = String.split(coordinate, ", ")
    {String.to_integer(x), String.to_integer(y)}
  end

  def generate_total_distances_on_grid(coordinates, {min_x, min_y, max_x, max_y}) do
    Enum.reduce(min_x..max_x, %{}, fn x, acc ->
      Enum.reduce(min_y..max_y, acc, fn y, acc ->
        process_coordinates_for_grid_point(x, y, coordinates, acc)
      end)
    end)
  end

  defp process_coordinates_for_grid_point(grid_x, grid_y, coordinates, acc) do
    sum =
      Enum.reduce(coordinates, 0, fn {x_coord, y_coord}, acc ->
        acc + taxicab_distance(grid_x, grid_y, x_coord, y_coord)
      end)

    Map.update(
      acc,
      sum,
      1,
      &(&1 + 1)
    )
  end

  defp find_region_size(region_sizes, threshold) do
    region_sizes
    |> Enum.reduce(0, fn {distance, count}, acc ->
      if distance < threshold do
        count + acc
      else
        acc
      end
    end)
  end

  def find_grid_size(coordinates) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coordinates, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coordinates, fn {_, y} -> y end)
    {min_x, min_y, max_x, max_y}
  end

  defp find_min_max_coordinates(coordinates) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coordinates, fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coordinates, fn {_, y} -> y end)
    {min_x, min_y, max_x, max_y}
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

      test "part 2" do
        assert answer(
                 [
                   "1, 1",
                   "1, 6",
                   "8, 3",
                   "3, 4",
                   "5, 5",
                   "8, 9"
                 ],
                 32
               ) == 16
      end
    end

  [input_file] ->
    File.read!(input_file)
    |> String.split("\n", trim: true)
    |> ChronalCoordinates.answer(10_000)
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

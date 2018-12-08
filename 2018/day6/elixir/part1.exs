# https://adventofcode.com/2018/day/5

defmodule ChronalCoordinates do
  def answer(raw_coordinates) do
    # Part 1
    # find min/max coordinates on grid ✅

    # Part 2 ✅
    # for each coordinate
    #   for each x/y
    #     calculate manhattan distance to item
    #     closest wins
    #
    # {
    #   0,0 => ["1,1", "1,6"]
    #   0,1 => ["1,1"]
    # }

    # Part 3
    # Iterate over borders into list
    # 0, 0 -> max-x, y
    # 0, 0 -> 0, max-y
    # max-x, 0 -> max-x, max-y
    # 0, max-y -> max-x, max-y

    # Part 4
    # Iterate over Map to create frequency map
    #   omit coordinates with more than 1 count
    #   omit coorderinates that appear in the infinity count list
    coordinates =
      raw_coordinates
      |> Enum.map(&process_raw_coordinate/1)

    grid_size = coordinates |> find_grid_size

    coordinates
    |> generate_distances_on_grid(grid_size)
    |> count_frequencies
    |> find_max_frequency
  end

  def process_raw_coordinate(coordinate) do
    [x, y] = String.split(coordinate, ", ")
    {int_x, _} = Integer.parse(x)
    {int_y, _} = Integer.parse(y)
    {int_x, int_y}
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
    coordinates
    |> Enum.reduce({}, &find_min_max_coordinates/2)
  end

  defp find_min_max_coordinates({x, y}, {}) do
    {x, y, x, y}
  end

  defp find_min_max_coordinates({x, y}, {min_x, min_y, max_x, max_y}) do
    acc_min_x =
      if x < min_x do
        x
      else
        min_x
      end

    acc_max_x =
      if x > max_x do
        x
      else
        max_x
      end

    acc_min_y =
      if y < min_y do
        y
      else
        min_y
      end

    acc_max_y =
      if y > max_y do
        y
      else
        max_y
      end

    {acc_min_x, acc_min_y, acc_max_x, acc_max_y}
  end

  defp count_frequencies(grid_calculations) do
    Map.to_list(grid_calculations)
    |> Enum.reduce(%{}, &process_coordinate/2)
  end

  defp find_max_frequency(frequency_counts) do
    {_, max_frequency} =
      frequency_counts
      |> Map.to_list()
      |> Enum.max_by(fn {_, count} -> count end)

    max_frequency
  end

  defp process_coordinate({_grid_coords, {_count, [coords]}}, map) do
    Map.update(map, coords, 1, &(&1 + 1))
  end

  defp process_coordinate({_grid_coords, {_count, [_head | _tail]}}, map) do
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

# https://adventofcode.com/2018/day/3

defmodule ClaimsOverlap do
  def get_overlaps(ids) do
    ids
    |> process_raw_instructions
    |> Enum.reduce(Map.new(), &set_markers/2)
    |> Map.values()
    |> Enum.count(fn current -> current > 1 end)
  end

  def set_markers(instructions, map) do
    [x, y, width, height] = instructions

    Enum.reduce(x..(x + (width - 1)), map, fn x_coord, accumx ->
      Enum.reduce(y..(y + (height - 1)), accumx, fn y_coord, accumy ->
        Map.update(accumy, {x_coord, y_coord}, 1, &(&1 + 1))
      end)
    end)
  end

  def process_raw_instructions(instructions) do
    instructions
    |> Enum.map(&String.replace(&1, ":", ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&Enum.slice(&1, 2..4))
    |> Enum.map(
      &Enum.reduce(&1, [], fn current, accum ->
        Enum.concat(accum, String.split(current, ~r{x|,}))
      end)
    )
    |> Enum.map(
      &Enum.map(&1, fn current ->
        String.to_integer(current)
      end)
    )
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule ClaimsOverlapTest do
      use ExUnit.Case

      import ClaimsOverlap

      test "puzzle" do
        assert get_overlaps([
                 "#1 @ 1,3: 4x4",
                 "#2 @ 3,1: 4x4",
                 "#3 @ 5,5: 2x2"
               ]) == 4
      end

      test "instructions" do
        instructions =
          process_raw_instructions([
            "#1 @ 1,3: 4x4",
            "#2 @ 3,1: 4x4",
            "#3 @ 5,5: 2x2"
          ])

        assert instructions == [
                 [1, 3, 4, 4],
                 [3, 1, 4, 4],
                 [5, 5, 2, 2]
               ]
      end

      test "set_markers" do
        markers = set_markers([1, 3, 4, 4], Map.new())

        assert markers ==
                 Map.new([
                   {{1, 3}, 1},
                   {{2, 3}, 1},
                   {{3, 3}, 1},
                   {{4, 3}, 1},
                   {{1, 4}, 1},
                   {{2, 4}, 1},
                   {{3, 4}, 1},
                   {{4, 4}, 1},
                   {{1, 5}, 1},
                   {{2, 5}, 1},
                   {{3, 5}, 1},
                   {{4, 5}, 1},
                   {{1, 6}, 1},
                   {{2, 6}, 1},
                   {{3, 6}, 1},
                   {{4, 6}, 1}
                 ])
      end
    end

  [input_file] ->
    File.stream!(input_file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> ClaimsOverlap.get_overlaps()
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

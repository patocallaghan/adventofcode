# https://adventofcode.com/2018/day/3

defmodule ProperClaim do
  def get_intact_claim(ids) do
    instructions =
      ids
      |> process_raw_instructions

    map =
      instructions
      |> Enum.reduce(Map.new(), &set_markers/2)

    instructions
    |> Enum.reject(fn current ->
      check_claim(map, current)
    end)
    |> Enum.reduce(nil, fn current, _accum ->
      Enum.at(current, 0)
    end)
  end

  def set_markers(instructions, map) do
    [_id, x, y, width, height] = instructions

    Enum.reduce(x..(x + (width - 1)), map, fn x_coord, accumx ->
      Enum.reduce(y..(y + (height - 1)), accumx, fn y_coord, accumy ->
        Map.update(accumy, {x_coord, y_coord}, 1, &(&1 + 1))
      end)
    end)
  end

  def process_raw_instructions(instructions) do
    instructions
    |> Enum.map(&String.replace(&1, ~r{:|#| @}, ""))
    |> Enum.map(&String.split(&1, " "))
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

  def check_claim(map, instructions) do
    [_id, x, y, width, height] = instructions

    Enum.reduce(x..(x + (width - 1)), false, fn x_coord, accumx ->
      Enum.reduce(y..(y + (height - 1)), accumx, fn y_coord, accumy ->
        cond do
          accumy == true ->
            true

          Map.get(map, {x_coord, y_coord}) != 1 ->
            true

          true ->
            false
        end
      end)
    end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule ProperClaimTest do
      use ExUnit.Case

      import ProperClaim

      test "puzzle" do
        assert get_intact_claim([
                 "#1 @ 1,3: 4x4",
                 "#2 @ 3,1: 4x4",
                 "#3 @ 5,5: 2x2"
               ]) == 3
      end

      test "instructions" do
        instructions =
          process_raw_instructions([
            "#1 @ 1,3: 4x4",
            "#2 @ 3,1: 4x4",
            "#3 @ 5,5: 2x2"
          ])

        assert instructions == [
                 [1, 1, 3, 4, 4],
                 [2, 3, 1, 4, 4],
                 [3, 5, 5, 2, 2]
               ]
      end
    end

  [input_file] ->
    File.stream!(input_file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> ProperClaim.get_intact_claim()
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

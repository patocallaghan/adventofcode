# https://adventofcode.com/2018/day/2

defmodule ChecksumCalculator do
  def get_checksum(ids) do
    ids
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(
      &Enum.reduce(&1, %{}, fn l, accum ->
        {_, accum} =
          Map.get_and_update(accum, l, fn current_value ->
            {l, (current_value || 0) + 1}
          end)

        accum
      end)
    )
    |> Enum.reduce(Map.new(), fn current, accum ->
      counts =
        Map.values(current)
        |> Enum.uniq()
        |> Enum.reduce(MapSet.new(), fn current, accum ->
          if current == 2 || current == 3 do
            MapSet.put(accum, current)
          else
            accum
          end
        end)

      accum =
        if MapSet.member?(counts, 2) do
          {_, accum} =
            Map.get_and_update(accum, "two", fn current_value ->
              {accum, (current_value || 0) + 1}
            end)

          accum
        else
          accum
        end

      accum =
        if MapSet.member?(counts, 3) do
          {_, accum} =
            Map.get_and_update(accum, "three", fn current_value ->
              {accum, (current_value || 0) + 1}
            end)

          accum
        else
          accum
        end

      IO.inspect(accum)
    end)
    |> Map.values()
    |> Enum.reduce(1, fn current, accum -> current * accum end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule ChecksumCalculatorTest do
      use ExUnit.Case

      import ChecksumCalculator

      test "range" do
        assert get_checksum([
                 "abcdef",
                 "bababc",
                 "abbcde",
                 "abcccd",
                 "aabcdd",
                 "abcdee",
                 "ababab"
               ]) == 12
      end
    end

  [input_file] ->
    File.stream!(input_file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> ChecksumCalculator.get_checksum()
    |> IO.puts()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

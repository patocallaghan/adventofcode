# https://adventofcode.com/2018/day/1

defmodule FrequencyFinder do
  def get_dupe_freq(numbers) do
    frequencies = MapSet.new()
    calculate_frequencies(numbers, frequencies, 0)
  end

  defp calculate_frequencies(numbers, frequencies, count) do
    {is_found, frequency, frequencies} =
      Enum.reduce_while(numbers, {:not_found, count, frequencies}, fn n,
                                                                      {_, accum, frequencies} ->
        accum = accum + n

        if MapSet.member?(frequencies, accum) do
          {:halt, {:found, accum, frequencies}}
        else
          frequencies = MapSet.put(frequencies, accum)
          {:cont, {:not_found, accum, frequencies}}
        end
      end)

    if is_found == :found do
      frequency
    else
      calculate_frequencies(numbers, frequencies, frequency)
    end
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule FrequencyFinderTest do
      use ExUnit.Case

      import FrequencyFinder

      test "range" do
        assert get_dupe_freq([+3, +3, +4, -2, -4]) == 10
        assert get_dupe_freq([-6, +3, +8, +5, -6]) == 5
        assert get_dupe_freq([+7, +7, -2, -7, -4]) == 14
      end
    end

  [input_file] ->
    input =
      File.stream!(input_file)
      |> Stream.map(&String.replace(&1, "\n", ""))
      |> Enum.map(fn line -> String.to_integer(line) end)

    IO.puts(FrequencyFinder.get_dupe_freq(input))

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

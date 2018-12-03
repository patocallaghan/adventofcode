# https://adventofcode.com/2018/day/1

defmodule FrequencySummer do
  def sum_freqs(input) do
    Enum.sum(input)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule FrequencySummerTest do
      use ExUnit.Case

      import FrequencySummer

      test "range" do
        assert sum_freqs([+1, +1, +1]) == 3
        assert sum_freqs([+1, +1, -2]) == 0
        assert sum_freqs([-1, -2, -3]) == -6
      end
    end

  [input_file] ->
    File.stream!(input_file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.to_integer(&1))
    |> FrequencySummer.sum_freqs()
    |> IO.puts()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

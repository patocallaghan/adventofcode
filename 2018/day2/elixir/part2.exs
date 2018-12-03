# https://adventofcode.com/2018/day/2

defmodule CommonWordCalculator do
  def get_common_letters(ids) do
    ids
    |> Enum.with_index()
    |> Enum.reduce([], fn {current, index}, accum ->
      Enum.slice(ids, (index + 1)..length(ids))
      |> Enum.reduce(accum, fn item, accum ->
        case hamming_distance(current, item) do
          1 ->
            [current, item]

          _ ->
            accum
        end
      end)
    end)
    |> calculate_common_letters()
  end

  defp hamming_distance(a, b) do
    if a === b do
      0
    else
      String.split(a, "", trim: true)
      |> Enum.with_index()
      |> Enum.count(fn {n, i} -> n != String.at(b, i) end)
    end
  end

  defp calculate_common_letters(results) do
    [a, b] = results

    String.split(a, "", trim: true)
    |> Enum.with_index()
    |> Enum.reject(fn {n, i} -> n != String.at(b, i) end)
    |> Enum.map(fn {n, _i} -> n end)
    |> Enum.join("")
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule CommonWordCalculatorTest do
      use ExUnit.Case

      import CommonWordCalculator

      test "range" do
        assert get_common_letters([
                 "abcde",
                 "fghij",
                 "klmno",
                 "pqrst",
                 "fguij",
                 "axcye",
                 "wvxyz"
               ]) == "fgij"
      end
    end

  [input_file] ->
    input =
      File.stream!(input_file)
      |> Enum.map(&String.replace(&1, "\n", ""))

    IO.puts(CommonWordCalculator.get_common_letters(input))

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

# https://adventofcode.com/2018/day/5

defmodule AlchemicalReduction do
  def answer(polymer) do
    ?a..?z
    |> Enum.map(&to_string([&1]))
    |> Task.async_stream(
      fn problematic_type ->
        IO.puts(problematic_type)

        polymer =
          polymer
          |> String.replace(problematic_type, "")
          |> String.replace(problematic_type |> String.upcase(), "")

        check_polymer(0, String.to_charlist(polymer))
      end,
      timeout: 60000
    )
    |> Stream.map(fn {:ok, res} -> res end)
    |> Enum.min()
  end

  def check_polymer(index, polymer) do
    cond do
      index + 1 == length(polymer) - 1 ->
        length(polymer)

      abs(Enum.at(polymer, index) - Enum.at(polymer, index + 1)) == 32 ->
        polymer =
          polymer
          |> List.delete_at(index + 1)
          |> List.delete_at(index)

        check_polymer(index - 1, polymer)

      true ->
        check_polymer(index + 1, polymer)
    end
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule AlchemicalReductionTest do
      use ExUnit.Case

      import AlchemicalReduction

      test "part 1" do
        assert answer("dabAcCaCBAcCcaDA") == 4
      end
    end

  [input_file] ->
    File.read!(input_file)
    |> AlchemicalReduction.answer()
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

# https://adventofcode.com/2018/day/5

defmodule AlchemicalReduction do
  def answer(polymer) do
    ?a..?z
    |> Enum.map(&to_string([&1]))
    |> Enum.reduce(%{}, fn problematic_type, acc ->
      # IO.puts(problematic_type)

      Map.put(
        acc,
        problematic_type,
        check_polymer(0, String.split(polymer, "", trim: true), problematic_type)
      )
    end)
    |> Map.values()
    |> Enum.min()
  end

  def check_polymer(index, polymer, problematic_type) do
    cond do
      index + 1 == length(polymer) ->
        IO.puts("#{Enum.at(polymer, index + 1)}")
        length(polymer)

      check_problematic_type(Enum.at(polymer, index), problematic_type) ->
        polymer =
          polymer
          |> List.delete_at(index)

        check_polymer(index - 1, polymer, problematic_type)

      check_units(Enum.at(polymer, index), Enum.at(polymer, index + 1)) ->
        polymer =
          polymer
          |> List.delete_at(index + 1)
          |> List.delete_at(index)

        check_polymer(index - 1, polymer, problematic_type)

      true ->
        check_polymer(index + 1, polymer, problematic_type)
    end
  end

  def check_problematic_type(a, problematic_type) do
    String.downcase(a) == problematic_type
  end

  def check_units(a, b) do
    a_codepoint =
      a
      |> String.to_charlist()
      |> Enum.at(0)

    b_codepoint =
      b
      |> String.to_charlist()
      |> Enum.at(0)

    abs(b_codepoint - a_codepoint) == 32
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

      test "check_units" do
        assert check_units("a", "a") == false
        assert check_units("A", "A") == false
        assert check_units("A", "a") == true
        assert check_units("a", "A") == true
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

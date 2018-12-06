# https://adventofcode.com/2018/day/5

defmodule AlchemicalReduction do
  def answer(polymer) do
    check_polymer(0, String.split(polymer, "", trim: true))
  end

  def check_polymer(index, polymer) do
    cond do
      index + 1 == length(polymer) ->
        IO.puts("#{Enum.at(polymer, index + 1)}")
        length(polymer)

      check_units(Enum.at(polymer, index), Enum.at(polymer, index + 1)) ->
        polymer =
          polymer
          |> List.delete_at(index + 1)
          |> List.delete_at(index)

        check_polymer(index - 1, polymer)

      true ->
        check_polymer(index + 1, polymer)
    end
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
        assert answer("dabAcCaCBAcCcaDA") == 10
        assert answer("dabACcaCBAcCcaDA") == 10

        assert answer("dabACCaCBAcCcaDA") == 14
        assert answer("dabAccaCBAcCcaDA") == 14
        assert answer("dabAccaCBACCCaDd") == 14

        assert answer(
                 "YmnSscUuUuwumMUWguUWwNDdnQqGKkfFkKRrUuPpfFIJjiLVvnNlPprRwVLlfFvKRrJjxXVvkWWwWwwrRxXaAWJvsSVjZzOmMoUuaAqQro"
               ) == 6
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

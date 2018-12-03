# https://adventofcode.com/2018/day/1

input = File.stream!("input.txt")
|> Stream.map( &(String.replace(&1, "\n", "")) )
|> Enum.map(fn(line) ->
  { intVal, "" } = Integer.parse(line)
  intVal
end)

defmodule FrequencyFinder do

  def get_dupe_freq(numbers) do
    frequencies = MapSet.new()
    calculate_frequencies(numbers, frequencies, 0);
  end

  defp calculate_frequencies(numbers, frequencies, count) do
    { is_found, frequency, frequencies } = Enum.reduce_while(numbers, {:not_found, count, frequencies }, fn (n, { _, accum, frequencies }) ->
      accum = accum + n
      if MapSet.member?(frequencies, accum) do
        { :halt, { :found, accum, frequencies } }
      else
        frequencies = MapSet.put(frequencies, accum)
        { :cont, { :not_found, accum, frequencies } }
      end
    end)

    if is_found == :found do
      frequency
    else
      calculate_frequencies(numbers, frequencies, frequency)
    end
  end
end

# example1 = [+3, +3, +4, -2, -4]
# example2 = [-6, +3, +8, +5, -6]
# example3 = [+7, +7, -2, -7, -4]
IO.puts FrequencyFinder.get_dupe_freq(input)
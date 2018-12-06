# https://adventofcode.com/2018/day/4

defmodule SleepingGuard do
  def answer(instructions) do
    parsed_instructions =
      instructions
      |> parse_instructions()
      |> process_guard_instructions()

    {guard_id, sleep_data} =
      parsed_instructions
      |> Enum.max_by(fn {_id, sleep_times} ->
        Enum.sum(Map.values(sleep_times))
      end)

    {minute, _} =
      sleep_data
      |> Map.to_list()
      |> Enum.max_by(fn {_, count} -> count end)

    minute * guard_id
  end

  def parse_instructions(instructions) do
    instructions
    |> Enum.sort()
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(instruction) do
    timestamp =
      String.split(instruction, "]")
      |> Enum.at(0)
      |> String.replace("[", "")
      |> String.replace(" ", "T")
      |> String.replace(~r[$], ":00Z")

    action =
      cond do
        String.contains?(instruction, "begins") ->
          :begin

        String.contains?(instruction, "falls asleep") ->
          :sleep

        true ->
          :wake
      end

    guard =
      if String.contains?(instruction, "begins") do
        results = Regex.named_captures(~r/#(?<id>\d+)/, instruction)

        String.to_integer(Map.get(results, "id"))
      else
        nil
      end

    {timestamp, action, guard}
  end

  # entries [
  #  {"1518-07-05T23:53:00Z", :begin, 1949}
  #  {"1518-07-06T00:10:00Z", :sleep, nil }
  #  {"1518-07-06T00:15:00Z", :wake, nil }
  # ]
  def process_guard_instructions(instructions) do
    {_, _, guard_entries} =
      Enum.reduce(instructions, {nil, nil, Map.new()}, fn instruction,
                                                          {current_timestamp, current_guard, map} ->
        {entry_timestamp, action, guard} = instruction

        case action do
          :begin ->
            {entry_timestamp, guard, map}

          :sleep ->
            {entry_timestamp, current_guard, map}

          :wake ->
            {entry_timestamp, current_guard,
             Map.update(
               map,
               current_guard,
               add_to_sleep(Map.new(), current_timestamp, entry_timestamp),
               fn current_value ->
                 add_to_sleep(current_value, current_timestamp, entry_timestamp)
               end
             )}
        end
      end)

    guard_entries
  end

  def add_to_sleep(map, previous_timestamp, current_timestamp) do
    {_, current_date_time, _} = DateTime.from_iso8601(current_timestamp)
    {_, previous_date_time, _} = DateTime.from_iso8601(previous_timestamp)

    Enum.reduce(previous_date_time.minute..(current_date_time.minute - 1), map, fn minute, acc ->
      Map.update(acc, minute, 1, &(&1 + 1))
    end)
  end
end

case System.argv() do
  ["--test"] ->
    ExUnit.start()

    defmodule SleepingGuardTest do
      use ExUnit.Case

      import SleepingGuard

      test "puzzle" do
        assert answer([
                 "[1518-11-01 00:00] Guard #10 begins shift",
                 "[1518-11-01 00:05] falls asleep",
                 "[1518-11-01 00:25] wakes up",
                 "[1518-11-01 00:30] falls asleep",
                 "[1518-11-01 00:55] wakes up",
                 "[1518-11-01 23:58] Guard #99 begins shift",
                 "[1518-11-02 00:40] falls asleep",
                 "[1518-11-02 00:50] wakes up",
                 "[1518-11-03 00:05] Guard #10 begins shift",
                 "[1518-11-03 00:24] falls asleep",
                 "[1518-11-03 00:29] wakes up",
                 "[1518-11-04 00:02] Guard #99 begins shift",
                 "[1518-11-04 00:36] falls asleep",
                 "[1518-11-04 00:46] wakes up",
                 "[1518-11-05 00:03] Guard #99 begins shift",
                 "[1518-11-05 00:45] falls asleep",
                 "[1518-11-05 00:55] wakes up"
               ]) == 240
      end

      test "parse instructions" do
        assert parse_instructions([
                 "[1518-11-03 00:05] Guard #10 begins shift",
                 "[1518-11-03 00:24] falls asleep",
                 "[1518-11-03 00:29] wakes up",
                 "[1518-11-05 00:03] Guard #99 begins shift",
                 "[1518-11-05 00:45] falls asleep",
                 "[1518-11-04 00:02] Guard #99 begins shift",
                 "[1518-11-04 00:36] falls asleep",
                 "[1518-11-04 00:46] wakes up",
                 "[1518-11-05 00:55] wakes up"
               ]) == [
                 {"1518-11-03T00:05:00Z", :begin, 10},
                 {"1518-11-03T00:24:00Z", :sleep, nil},
                 {"1518-11-03T00:29:00Z", :wake, nil},
                 {"1518-11-04T00:02:00Z", :begin, 99},
                 {"1518-11-04T00:36:00Z", :sleep, nil},
                 {"1518-11-04T00:46:00Z", :wake, nil},
                 {"1518-11-05T00:03:00Z", :begin, 99},
                 {"1518-11-05T00:45:00Z", :sleep, nil},
                 {"1518-11-05T00:55:00Z", :wake, nil}
               ]
      end

      test "add to sleep" do
        assert add_to_sleep(Map.new(), "1518-07-06T00:10:00Z", "1518-07-06 00:15:00Z") ==
                 Map.new([{10, 1}, {11, 1}, {12, 1}, {13, 1}, {14, 1}])

        assert add_to_sleep(
                 Map.new([{10, 1}, {11, 1}, {12, 1}, {13, 1}, {14, 1}]),
                 "1518-07-06T00:10:00Z",
                 "1518-07-06 00:15:00Z"
               ) == Map.new([{10, 2}, {11, 2}, {12, 2}, {13, 2}, {14, 2}])
      end

      test "process_guard_instructions" do
        assert process_guard_instructions([
                 {"1518-07-05T23:53:00Z", :begin, 1949},
                 {"1518-07-06T00:10:00Z", :sleep, nil},
                 {"1518-07-06T00:15:00Z", :wake, nil}
               ]) == Map.new([{1949, Map.new([{10, 1}, {11, 1}, {12, 1}, {13, 1}, {14, 1}])}])
      end
    end

  [input_file] ->
    File.stream!(input_file)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> SleepingGuard.answer()
    |> IO.inspect()

  _ ->
    IO.puts(:stderr, "We expected --test or an input file")
    System.halt(1)
end

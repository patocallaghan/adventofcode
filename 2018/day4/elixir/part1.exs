# https://adventofcode.com/2018/day/4

defmodule SleepingGuard do
  def answer(entries) do
    data =
      entries
      |> parse_entries()
      |> update_guard_entries()

    max =
      data
      |> Enum.max_by(fn {_id, sleep_chart} ->
        Enum.sum(Map.values(sleep_chart))
      end)

    {id, _sum, minute} =
      [max]
      |> Enum.reduce({}, fn {id, map}, acc ->
        {minute, _} = Enum.max_by(Map.to_list(map), fn {_, count} -> count end)
        {id, Enum.sum(Map.values(map)), minute}
      end)

    minute * id
  end

  def parse_entries(entries) do
    entries
    |> Enum.sort()
    |> Enum.map(&parse_entry/1)
  end

  def find_max_and_minute(entry) do
    [entry]
  end

  # "[1518-11-01 00:00] Guard #10 begins shift",
  # "[1518-11-01 00:05] falls asleep",
  # "[1518-11-01 00:25] wakes up",
  defp parse_entry(entry) do
    timestamp =
      String.split(entry, "]")
      |> Enum.at(0)
      |> String.replace("[", "")
      |> String.replace(" ", "T")
      |> String.replace(~r[$], ":00Z")

    action =
      cond do
        String.contains?(entry, "begins") ->
          :begin

        String.contains?(entry, "falls asleep") ->
          :sleep

        true ->
          :wake
      end

    guard =
      if String.contains?(entry, "begins") do
        results = Regex.named_captures(~r/#(?<id>\d+)/, entry)

        String.to_integer(Map.get(results, "id"))
      else
        nil
      end

    {timestamp, action, guard}
  end

  # entries [
  #  {"1518-07-05T23:53:00Z", :begin, 1949}
  #  {"1518-07-06T00:10:00Z", :sleep, 1949 }
  #  {"1518-07-06T00:15:00Z", :wake, 1949 }
  # ]
  def update_guard_entries(entries) do
    {_, _, guard_entries} =
      Enum.reduce(entries, {nil, nil, Map.new()}, fn entry,
                                                     {current_timestamp, current_guard, map} ->
        {entry_timestamp, action, guard} = entry

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

    Enum.reduce(previous_date_time.minute..(current_date_time.minute - 1), map, fn minute,
                                                                                   accum ->
      Map.update(accum, minute, 1, fn current_value -> current_value + 1 end)
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

      test "parse entries" do
        assert parse_entries([
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

      test "update_guard_entries" do
        assert update_guard_entries([
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
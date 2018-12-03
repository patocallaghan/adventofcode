# https://adventofcode.com/2018/day/1

IO.puts File.stream!("input.txt")
|> Stream.map( &(String.replace(&1, "\n", "")) )
|> Enum.reduce( 0, fn(line, acc) ->
  { intVal, "" } = Integer.parse(line)
  acc + intVal
end)
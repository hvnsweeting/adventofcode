# Advent Of Code 2018, 2019 - in Elixir

[![CircleCI](https://circleci.com/gh/hvnsweeting/adventofcode.svg?style=svg)](https://circleci.com/gh/hvnsweeting/adventofcode)

## Lessons learned
- Unittest is troublesome at the beginning but super useful after a NOT SO LONG run, even 1 hour of code. Refactor then is just a breeze.
- `IO.inspect` does not work with multiple args, but can use a tuple to wrap
  them up and inspect.
- `h cond` shows help info for `cond`, same for everything else, very helpful.
- String concat uses `<>` not `+`, DateTime comparation using `DateTime.compare`, not `>` or `<`.
- Regex is super handy for parsing, `Regex.scan(~r{#(\d+)}, string)`
- When defining a anonymous function, after `->`, enter to new line for reading sake.
- `'a'` is a char list, `"a"` is a string, convertion is explicit. `String.to_charlist("a")`. Since `'a'` a list, get the codepoint of the char must use `List.first('a')`:
  ```elixir
  iex(14)> List.first('ứ')
    7913
  ```
- `String.split(",")` is valid, even you forgot adding string to split `String.split(string, ",")`
- `IO.inspect` returns its input, thus, make it transparent to the
  pipeline, add it anywhere you want to debug. E.g
  ```elixir
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn s -> String.split(s, ", ") end)
  ```
  Can add it
  ```elixir
    |> String.split("\n", trim: true)
    |> IO.inspect   # here to view intermediate result
    |> Enum.map(&String.trim/1)
    |> IO.inspect   # here to view intermediate result
    |> Enum.map(fn s -> String.split(s, ", ") end)
  ```

# Advent Of Code 2018, 2019, 2020 - in Elixir

[![Build Status](https://travis-ci.org/hvnsweeting/adventofcode.svg?branch=master)](https://travis-ci.org/hvnsweeting/adventofcode)
[![CircleCI](https://circleci.com/gh/hvnsweeting/adventofcode.svg?style=svg)](https://circleci.com/gh/hvnsweeting/adventofcode)

## Lessons learned
### On AdventOfCode
- Always download the input file before solving problem,
  especially when visitting an old-unsolved
  problem.  Human makes mistake, things mess up, you might save wrong input file
  and wonder why your code is flawless but still got no result.
- Solving problem is not necessary to use code. E.g problem 2019 day 25 part 1
  can be done by hand with pencil draw the maze under 15 minutes. Coding would
  take longer.
- Part 2 **often** requires another approach, a completely new way to solve,
  it often gives big number make using naive code that solve part 1
  impracticle to run. Solution for part 2 may not work on part 1, part 2 can be
  a big, but special case. E.g Day 16 2019 part 2 can only be solved base on
  a condition that not exist in part 1.
- When in doubt, print out/ draw.

### On Elixir
- Prefer `Enum.filter |> length` over Enum.count, the former is more general, and
  allow to put inspect in the middle.
- For AOC fast coding, `import Enum`
- Use `IO.inspect` not `inspect` which
  returns a string not pass-through like the former
- Avoid append a list by `a ++ [b]`, it is `O(n)`, while similar
  to `[b|a] |> Enum.reverse` - `O(1 + n)` for one call, but put into a loop, it
  is huge different. The latter version would be `O(m + m)` while the former
  is `O(m^2)`.
- Always call function with `()` notation. Surprise?:
  ```elixir
  > Base.encode16 :crypto.hash(:sha256, "PYMI.vn") |> String.downcase
  "8C9161716A6B85E1CA72E0348569ACA3E27167FA15C37768B07D8BE490F9AAFC"
  # WHY NO DOWN CASE??!!!
  > Base.encode16(:crypto.hash(:sha256, "PYMI.vn")) |> String.downcase
  "8c9141714a6b85e1ca72e0348549aca3e25147fa15c37768b07d8be490f9aafc"
  ```
- Unittest is troublesome at the beginning but super useful after a NOT SO LONG
  run, even 1 hour of code. Refactor then is just a breeze.
- `IO.inspect(label: "a label to pring")` would be more handy than without label.
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
- Avoid usage of same function name for variadic arguments. It makes it hard
to distinguish/find definition if your IDE/editor not support to find foo/2 vs
foo/3 vs foo/4, hard to read, too. Just use other name.
- Empty map matches all maps. Use guard `map_size(m)` instead.
- Get familiar with writing reduce function separatedly as they could be recursive also.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `adventofcode` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:adventofcode, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/adventofcode](https://hexdocs.pm/adventofcode).

# Aoc2025

- Day 02: SURPRISE! Elixir allow 1..10 but also 10..1 and only output a warning: `warning: 10..1 has a default step of -1, please write 10..1//-1 instead`. If you want it to behave like Python that range(10, 1) must be empty, then explicit add the step `x..y//1`:
  ```elixir
  iex(3)> x = 10
  10
  iex(4)> y = 1
  1
  iex(5)> x..y//1
  10..1//1
  iex(6)> x..y//1 |> Enum.to_list
  []
  iex(7)> x..y//-1 |> Enum.to_list
  [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  # RANGE IS INCLUSIVE
  ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aoc2025` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aoc2025, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/aoc2025>.


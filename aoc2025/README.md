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
- Day03: Enum.max raises error if input list is empty, and it returns latest max value, not first one.
  ```elixr
  iex(41)> Enum.max([], &>=/2, fn -> 0 end)
  0
  iex(42)> Enum.max([])
  ** (Enum.EmptyError) empty error
      (elixir 1.18.0-dev) lib/enum.ex:1915: anonymous fn/0 in Enum.max/1
      iex:42: (file)
  iex(43)> Enum.max([{8, 1}, {8, 2}])
  {8, 2}
  iex(44)> Enum.max_by([{8, 1}, {8, 2}], fn {x, _} -> x end)
  {8, 1}
  ```
  Use `Integer.digits` and `Integer.undigits` for quick converting number to list of digits:
  ```elixir
  iex(49)> Integer.digits(123)
  [1, 2, 3]
  iex(50)> Integer.undigits([1,2,3])
  123
  ```

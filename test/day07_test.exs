defmodule Day07Test do
  use ExUnit.Case, async: true
  doctest Day07
  @example "Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin."

  @map %{
    "C" => ["A", "F"],
    "A" => ["B", "D"],
    "B" => ["E"],
    "D" => ["E"],
    "F" => ["E"]
  }

  test "step mapping" do
    assert @example |> Day07.string_to_steps() == @map
  end

  test "solve" do
    assert @example |> Day07.solve_part1() == "CABDFE"
  end
end

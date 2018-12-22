defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "greets the world" do
    assert Day05.hello() == :hello
  end

  test "diff of c and C is 32" do
    assert Day05.char_diff('c', 'C') == 32
    assert Day05.char_diff('C', 'c') == 32
  end

  ## This test only work with slow version
  # test "react once dabAcCaCBAcCcaDA  The first 'cC' is removed." do
  #  assert Day05.react_once("dabAcCaCBAcCcaDA") == "dabAaCBAcCcaDA"
  # end

  test "react once dabCBAcaDA does not change" do
    assert Day05.react_once("dabCBAcaDA") == "dabCBAcaDA"
  end

  test "react stack got correct resutl dabCBAcaDA does not change" do
    assert Day05.react_stack("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
  end

  test "example part2" do
    assert Day05.solve_part2("dabAcCaCBAcCcaDA") == 4
  end

  test "all uniq units in abaBacC is abc" do
    assert Day05.all_uniq_units("abaBacC") == 'abc'
  end

  test "remove a unit" do
    assert Day05.remove_one_unit_type(List.first('a'), "dabAcCaCBAcCcaDA") == 6
  end

  test "example part1" do
    # dabAcCaCBAcCcaDA  The first 'cC' is removed.
    # dabAaCBAcCcaDA    This creates 'Aa', which is removed.
    # dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
    # dabCBAcaDA        No further actions can be taken.
    s = "dabAcCaCBAcCcaDA"
    assert Day05.react(s) == "dabCBAcaDA"
  end
end

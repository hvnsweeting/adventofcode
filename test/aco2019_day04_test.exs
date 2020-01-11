defmodule Aco2019Day04Test do
  use ExUnit.Case, async: true
  doctest Aoc2019Day4
  @start 387_638
  @stop 919_123
  test "Solve part 1" do
    assert Aoc2019Day4.solve_part_1(@start, @stop) == 466
  end

  test "Solve part 2" do
    assert Aoc2019Day4.solve_part_2(@start, @stop) == 292
  end

  test "111111 meets these criteria (double 11, never decreases)." do
    assert Aoc2019Day4.valid_password?("111111", 100_000, 200_000) == true
  end

  test "388888 meets these criteria (double 88, never decreases)." do
    assert Aoc2019Day4.has_at_least_to_same_adjacent_digits?(String.to_charlist("388888")) == true
    assert Aoc2019Day4.valid_password?("388888", 100_000, 500_000) == true
  end

  test " 223450 does not meet these criteria (decreasing pair of digits 50). " do
    assert Aoc2019Day4.valid_password?("223450", 100_000, 500_000) == false
  end

  test " 123789 does not meet these criteria (no double). " do
    assert Aoc2019Day4.valid_password?("123789", 100_000, 200_000) == false
  end

  test "  112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long." do
    assert Aoc2019Day4.has_two_adjacent_digits?(String.to_charlist("112233")) == true
  end

  test "  123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444)." do
    assert Aoc2019Day4.has_two_adjacent_digits?(String.to_charlist("123444")) == false
  end

  test "  111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22)." do
    assert Aoc2019Day4.has_two_adjacent_digits?(String.to_charlist("111122")) == true
  end
end

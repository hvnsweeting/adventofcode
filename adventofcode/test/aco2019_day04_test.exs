defmodule Aco2019Day04Test do
  use ExUnit.Case
  doctest Aoc2019Day4
  @start 387_638
  @stop 919_123
  test "Solve part 1" do
    assert Aoc2019Day4.solve_part_1(@start, @stop) == 466
  end

  test "111111 meets these criteria (double 11, never decreases)." do
    assert Aoc2019Day4.valid_password?("111111", 100_000, 200_000) == true
  end

  test "388888 meets these criteria (double 88, never decreases)." do
    assert Aoc2019Day4.has_two_adjacent_digits?(String.to_charlist("388888")) == true
    assert Aoc2019Day4.valid_password?("388888", 100_000, 500_000) == true
  end

  test " 223450 does not meet these criteria (decreasing pair of digits 50). " do
    assert Aoc2019Day4.valid_password?("223450", 100_000, 500_000) == false
  end

  test " 123789 does not meet these criteria (no double). " do
    assert Aoc2019Day4.valid_password?("123789", 100_000, 200_000) == false
  end
end

defmodule Aoc2025Test do
  use ExUnit.Case

  test "1212 is invalid" do
    assert Aoc2025.is_invalid?("1212") == true
  end

  test "1698522 is valid" do
    assert Aoc2025.is_invalid?("1698522") == false
  end

  @input "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
  test "solve" do
    assert Aoc2025.solve(@input) == 1_227_775_554
    # {:ok, text} = File.read("test/input01")
    # assert Aoc2025.solve(text) == 30323879646
  end

  test "solve2" do
    assert Aoc2025.solve2(@input) == 4_174_379_265
    # {:ok, text} = File.read("test/input01")
    # assert Aoc2025.solve2(text) == 43872163557
  end

  test "666" do
    assert Aoc2025.is_invalid_v2?("666") == true
  end
end

defmodule Aoc2025.Day06.Test do
  use ExUnit.Case

  @example "123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
"
  test "solve" do
    assert Aoc2025.Day06.solve1(@example) == 4_277_556
    {:ok, text} = File.read("test/input06")
    assert Aoc2025.Day06.solve1(text) == 6_635_273_135_233
  end

  test "solve2" do
    assert Aoc2025.Day06.solve2(@example) == 3_263_827
    {:ok, text} = File.read("test/input06")
    assert Aoc2025.Day06.solve2(text) == 12_542_543_681_221
  end
end

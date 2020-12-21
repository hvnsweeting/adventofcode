defmodule Aoc2020Day21Test do
  use ExUnit.Case

    @input "
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
    "
  test "1" do
    assert Aoc2020Day21.solve1(@input) == 5
    {:ok, input} = File.read("test/input2020_21")
    assert Aoc2020Day21.solve1(input) == 2150
  end

  test "2" do
    assert Aoc2020Day21.solve2(@input) == "mxmxvkd,sqjhc,fvjkl"
    {:ok, input} = File.read("test/input2020_21")
    assert Aoc2020Day21.solve2(input) == "vpzxk,bkgmcsx,qfzv,tjtgbf,rjdqt,hbnf,jspkl,hdcj"

  end
end

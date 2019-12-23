defmodule Aoc2019Day16Test do
  use ExUnit.Case

  @input "59734319985939030811765904366903137260910165905695158121249344919210773577393954674010919824826738360814888134986551286413123711859735220485817087501645023012862056770562086941211936950697030938202612254550462022980226861233574193029160694064215374466136221530381567459741646888344484734266467332251047728070024125520587386498883584434047046536404479146202115798487093358109344892308178339525320609279967726482426508894019310795012241745215724094733535028040247643657351828004785071021308564438115967543080568369816648970492598237916926533604385924158979160977915469240727071971448914826471542444436509363281495503481363933620112863817909354757361550"
  test "Then, only the ones digit is kept: 38 becomes 8" do
    assert Aoc2019Day16.ones_digit(38) == 8
  end

  test "-17 becomes 7" do
    assert Aoc2019Day16.ones_digit(-17) == 7
  end

  # test "if the input list were 9, 8, 7, 6, 5 and the pattern for a given element were 1, 2, 3, the result would be 9*1 + 8*2 + 7*3 + 6*1 + 5*2" do
  #  input_list = [9, 8, 7, 6, 5]
  #  pattern = [1, 2, 3]
  #  assert Aoc2019Day16.make_element(input_list, pattern) == 9 * 1 + 8 * 2 + 7 * 3 + 6 * 1 + 5 * 2
  # end

  test "Raw pattern for 3rd elem is 0, 0, 0, 1, 1, 1, 0, 0, 0, -1, -1, -1 from base pattern 0, 1, 0, -1. " do
    nth = 3
    base_pattern = [0, 1, 0, -1]

    assert Aoc2019Day16.raw_pattern(base_pattern, nth) |> Enum.take(12) == [
             0,
             0,
             0,
             1,
             1,
             1,
             0,
             0,
             0,
             -1,
             -1,
             -1
           ]
  end

  test "Input signal 12345678 -> FFT After 1 phase: 48226158" do
    assert Aoc2019Day16.solve1("12345678", 1) == "48226158"
  end

  # test "Input signal 12345678 x 2-> FFT After 1 phase: 48226158" do
  #  assert Aoc2019Day16.solve2("12345678", 1) == "48226158"
  # end

  test "Input signal 12345678 -> FFT After 2 phase: 34040438" do
    assert Aoc2019Day16.solve1("12345678", 2) == "34040438"
  end

  test "Input signal 12345678 -> FFT After 3 phase: 03415518" do
    assert Aoc2019Day16.solve1("12345678", 3) == "03415518"
  end

  test "Input signal 12345678 -> FFT After 4 phase: 01029498" do
    assert Aoc2019Day16.solve1("12345678", 4) == "01029498"
  end

  test "Input signal 80871224585914546619083218645595 -> FFT After 100 phases: 24176176" do
    assert Aoc2019Day16.solve1("80871224585914546619083218645595", 100) == "24176176"
  end

  @tag slow: true
  # test "solve 1" do
  #  {:ok, input} = File.read("test/input2019_16_1.txt")
  #  assert Aoc2019Day16.solve1(input) == "37153056"
  # end

  test "Input signal 12345678 -> FFT After 1 phase: 48226158 offset 3 -> 26158" do
    inp = Aoc2019Day16.as_list("12345678") |> Enum.drop(3)
    assert Aoc2019Day16.apply_phases(inp, 1) == "26158"
  end

  test "signal 12345678 -> FFT After 4 phases: offset 3 -> 010_29498 -> 29498" do
    inp = Aoc2019Day16.as_list("12345678") |> Enum.drop(3)
    assert Aoc2019Day16.apply_phases(inp, 4) == "29498"
  end

  test "signal 69317163492948606335995924319873  -> FFT After 100 phases:52432133 " do
    inp = Aoc2019Day16.as_list("69317163492948606335995924319873")
    assert Aoc2019Day16.apply_phases(inp, 100) |> String.slice(0, 8) == "52432133"
  end

  test "new way to calculate 1 digit without create 0 1 0 -1 stream" do
    # input = "12345678"
    inp = Aoc2019Day16.as_list("12345678")
    assert Aoc2019Day16.calculate(inp, 1) == {4, 1}
    assert Aoc2019Day16.calculate(inp, 2) == {8, 2}

    assert Aoc2019Day16.doone(inp)
           |> Enum.map(fn {v, _} -> Integer.to_string(v) end)
           |> Enum.join("") == "48226158"

    assert Aoc2019Day16.doone(inp)
           |> Aoc2019Day16.doone()
           |> Enum.map(fn {v, _} -> Integer.to_string(v) end)
           |> Enum.join("") == "34040438"

    assert Aoc2019Day16.doone(inp)
           |> Enum.drop(3)
           |> Enum.map(fn {v, _} -> Integer.to_string(v) end)
           |> Enum.join("") == "26158"

    assert Aoc2019Day16.doone(inp)
           |> Aoc2019Day16.doone()
           |> Enum.map(fn {v, _} -> Integer.to_string(v) end)
           |> Enum.drop(3)
           |> Enum.join("") == "40438"

    inp = Aoc2019Day16.as_list("12345123451234512345")

    assert Aoc2019Day16.doone(inp)
           |> Enum.map(fn {v, _} -> Integer.to_string(v) end)
           |> Enum.join("") == "06030407700974054295"
  end

  @tag timeout: :infinity
  test "03036732577212944063491565474664 x 10000 times -> FFT 1 phases  " do
    # FFT 100 times becomes 84462026 but slow
    input = "03036732577212944063491565474664"

    inp =
      input
      |> String.to_charlist()
      |> Enum.map(fn d -> d - ?0 end)
      |> Stream.cycle()
      |> Stream.with_index(1)
      |> Enum.take(10000 * String.length(input))
      |> Enum.drop(303_673)

    assert Aoc2019Day16.apply_phases(inp, 1) |> String.slice(0, 8) == "61706040"
  end

  @tag timeout: :infinity
  test "FAST 12345 x 4 times, offset 14 becomes 054295 " do
    input = "12345"

    inp =
      input
      |> String.to_charlist()
      |> Enum.map(fn d -> d - ?0 end)
      |> Stream.cycle()
      |> Enum.take(20)

    assert Aoc2019Day16.loop(inp, 1) |> String.slice(-6, 6) == "054295"
  end

  @tag timeout: :infinity
  test "FAST 03036732577212944063491565474664 x 10000 times -> FFT 100 phases  becomes 84462026 " do
    input = "03036732577212944063491565474664"
    assert Aoc2019Day16.solve2(input, 100) == "84462026"
    input = "02935109699940807407585447034323"
    assert Aoc2019Day16.solve2(input, 100) == "78725270"
    input = "03081770884921959731165446850517"
    assert Aoc2019Day16.solve2(input, 100) == "53553731"
    assert Aoc2019Day16.solve2(@input, 100) == "60592199"
  end

  test "solve 2" do
    {:ok, input} = File.read("test/input2019_16_1.txt")
    assert input |> String.trim() == @input
    assert Aoc2019Day16.solve2(input, 100) == "60592199"
  end
end

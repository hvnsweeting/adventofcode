defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  test "greets the world" do
    assert Day04.hello() == :hello
  end

  test "parse date" do
    assert Day04.parse_datetime("[1518-11-01 00:00] Guard #10 begins shift") == elem(DateTime.from_iso8601("1518-11-01 00:00:00+0000"), 1)
  end

  test "get id" do
    assert Day04.get_id("[1518-11-01 00:00] Guard #10 begins shift") == 10
  end

  test "get minute " do
    assert Day04.get_minute("[1518-11-01 00:05] falls asleep") == 5
    assert Day04.get_minute("[1518-11-01 00:25] wakes up") == 25
  end

  test "calculate sleep time" do
    r = "[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up" |> String.split("\n", trim: true) |> Day04.calculate_sleep_time({}, Map.new)
    assert r == %{10 => Map.merge(
      Map.new(5..24, fn x -> {x, 1} end),
      Map.new(30..54, fn x -> {x, 1} end)
    )
    }
  end


  test "solve" do
    r = "[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-02 00:05] falls asleep
[1518-11-02 00:06] wakes up
[1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up" |> String.split("\n", trim: true) |> Day04.solve
    assert r == 10 * 5
  end


  test "solve example" do
    r = "[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up"
|> String.split("\n", trim: true) |> Day04.solve
    assert r == 10 * 24
  end


  test "solve example part 2" do
    r = "[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up"
|> String.split("\n", trim: true) |> Day04.solve2
    assert r == 99 * 45
  end
end

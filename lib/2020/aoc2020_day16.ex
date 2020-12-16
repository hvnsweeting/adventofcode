defmodule Aoc2020Day16 do

  import Enum
  def read_input(input) do
    input
    |> String.trim
    |> String.split("\n", trim: true)
  end

  @rules "
departure location: 27-374 or 395-974
departure station: 40-287 or 295-953
departure platform: 27-554 or 570-961
departure track: 40-604 or 618-958
departure date: 43-842 or 850-972
departure time: 30-302 or 315-952
arrival location: 32-478 or 496-950
arrival station: 48-733 or 755-969
arrival platform: 37-260 or 276-954
arrival track: 40-512 or 519-964
class: 34-277 or 284-966
duration: 25-648 or 672-961
price: 28-684 or 705-956
route: 30-157 or 176-950
row: 47-881 or 903-970
seat: 38-705 or 727-959
train: 40-195 or 217-961
type: 28-858 or 879-958
wagon: 31-543 or 554-967
zone: 49-790 or 816-953
"
  def parse_rules(s) do
    lines = s |> String.trim |> String.split("\n", trim: true)

    lines
    |> Enum.map(&(parse_line(&1)))
  end

  def parse_line(s) do
    [name, value] = s |> String.split(":", trim: true)
    [range1, range2] = value |> String.trim |> String.split("or", trim: true)
    m1 = Regex.named_captures(~r/(?<s1>[0-9]+)-(?<e1>[0-9]+)/, range1)
    m2 = Regex.named_captures(~r/(?<s1>[0-9]+)-(?<e1>[0-9]+)/, range2)
    IO.inspect({m1, m2})
    f1 = fn x ->
      IO.inspect({m1["s1"], x, m1["e1"]})
      r = ((String.to_integer(m1["s1"]) <= x && x <=  String.to_integer(m1["e1"]) ) || (String.to_integer(m2["s1"]) <= x && x <=  String.to_integer(m2["e1"])))
    end
    f1

  end

  def solve1(input) do

    rules = parse_rules("class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50")
    #
#    input = "7,3,47
#40,4,50
#55,2,20
#38,6,12"
    xs =input
    |> read_input
    rules = parse_rules(@rules)

    xs
    |> Enum.map(fn x ->
      cs = String.split(x, ",", trim: true)

      Enum.map(cs, &(String.to_integer/1))
    end)

    |> map(fn xs ->
      xs |> map(fn x ->
        vs =map(rules, fn r -> !r.(x) end)

        IO.inspect({"each", x, vs})
        if all?(vs) do
          x
        else
          0
        end

    #zip(rules, xs) |> map(fn {f, xs} -> f.(xs)
    #|> Enum.all?
    end)  |> Enum.sum #Enum.all? #IO.inspect |> map(fn x -> Enum.all?(x) end)
    #|> filter
    end)
    |> sum
    #|> filter(fn x -> x == true end)
    #|> length

  end

end

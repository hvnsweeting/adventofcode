defmodule Aoc2020Day24Test do
  use ExUnit.Case

  @input "
  sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
  "

  test "1" do
    assert Aoc2020Day24.solve1(@input) == 10
    {:ok, text} = File.read("test/input2020_24")
    assert Aoc2020Day24.solve1(text) == 300
  end

  test "2" do
    assert Aoc2020Day24.solve2(@input) == 2208
    {:ok, text} = File.read("test/input2020_24")
    assert Aoc2020Day24.solve2(text) == 3466
  end
end

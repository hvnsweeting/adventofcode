defmodule AOC2018_1_2 do

  def solve(changes, base_changes, freq_now, reached_frequencies) do
      [h|t] = changes

      if MapSet.member?(reached_frequencies, freq_now + h) do
        freq_now + h
      else
        solve(t, base_changes, freq_now + h, MapSet.put(reached_frequencies, freq_now+h))
      end
  end

  def main() do
    inp = File.read!("/Users/viethung.nguyen/Downloads/aoc_2.txt")
          |> String.trim() |> String.split("\n")
          |> Enum.map(&String.to_integer/1) |> Stream.cycle
    solve(inp, inp, 0, MapSet.new) |> IO.inspect
  end
end

AOC2018_1_2.main()

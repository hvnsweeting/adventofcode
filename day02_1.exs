defmodule Day02 do
  def count(s) do
    String.to_charlist(s) |> do_count(%{})
  end
  defp do_count([], counter) do
    s = MapSet.new(counter |> Map.values)
    two = if MapSet.member?(s, 2) do
      1
    else
      0
    end
    three = if MapSet.member?(s, 3) do
      1
    else
      0
    end
    {two, three}
    #:maps.filter(fn _, v -> v ==3 || v == 2  end, counter) |> Map.to_list
  end
  defp do_count([h|t], counter) do
    if Map.has_key?(counter, h) do
      do_count(t, Map.put(counter, h, Map.get(counter, h) + 1))
    else
      do_count(t, Map.put(counter, h, 1))
    end
  end

  def product({two, three}) do
    two * three
  end


  def main() do
    #["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]
    File.read!("/Users/viethung.nguyen/Downloads/day02_1.txt")
    |> String.trim() |> String.split("\n")
    |> Enum.map(&count/1)
    |> Enum.reduce(fn {x, y}, {two, three} -> {two + x, three + y} end)
    |> product
    |> IO.inspect
  end
end

Day02.main()

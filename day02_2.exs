defmodule Day02_2 do
  def main() do
	inp = ["abcde",
		"fghij",
		"klmno",
		"pqrst",
		"fguij",
		"axcye",
		"wvxyz",
	]

    inp = File.read!("/Users/viethung.nguyen/Downloads/day02_1.txt") |> String.trim() |> String.split("\n")
    all_pairs = make_pairs(inp, inp)
    out = Enum.drop_while(all_pairs, fn x -> diff(x) != {} end) |> List.first
    IO.inspect(common(out))
  end
  def common({s1, s2}) do
    cl1 = String.to_charlist(s1)
    cl2 = String.to_charlist(s2)
    do_common(cl1, cl2, [])
  end
  def do_common([], [], r) do
    List.to_string(r)
  end
  def do_common([h1|l1], [h2|l2], r) do
    if h1 == h2 do
      do_common(l1, l2, r ++ [h1])
    else
      do_common(l1, l2, r)
    end
  end
  def make_pairs([], _) do
    []
  end
  def make_pairs([h1|t1], list) do
    _make_pair(h1, list) ++ make_pairs(t1, list)
  end
  def _make_pair(_, []) do
    []
  end
  def _make_pair(one, [h|t]) do
    [{one, h}] ++ _make_pair(one, t)
  end
  def diff({s1, s2}) do
    r = Enum.zip( String.to_charlist(s1), String.to_charlist(s2))
        |> Enum.reduce(0, fn {a, b}, acc -> if a != b, do: acc + 1, else: acc end)
    if r == 1 do
      {}
    else
      {s1, s2}
    end
  end
end

Day02_2.main()

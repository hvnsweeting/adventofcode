defmodule Aoc2020Day19 do
  import Enum

  def read_input(input) do
    [rules, messages] =
      input
      |> String.trim()
      |> String.replace("\"", "")
      |> String.split("\n\n", trim: true)

    rules =
      rules
      |> String.split("\n", trim: true)
      |> map(&parse_rule(&1))
      |> Map.new()

    {rules, messages}
  end

  def resolve(rules, name) do
    subrules = rules[name]
    # if name == "8" do
    #  IO.inspect({name, subrules})
    # else
    # end

    # subrules = case find_index(subrules, fn x -> x == name end) do
    #  nil -> subrules
    #  i ->
    #    List.replace_at(subrules, i, "*")
    # end

    r =
      cond do
        subrules == MapSet.new([["a"]]) ->
          "a"

        subrules == MapSet.new([["*"]]) ->
          "(?R)"

        subrules == MapSet.new([["b"]]) ->
          "b"

        true ->
          # IO.inspect({name, subrules}, label: "subrule")

          case is_list(subrules) do
            true ->
              # IO.inspect({"is list", subrules})
              subrules
              |> map(fn sr -> map(sr, "(" <> &(resolve(rules, &1) <> ")")) end)
              |> join("")

            false ->
              # IO.inspect({"not list", subrules})
              r = subrules |> map(fn sr -> map(sr, &resolve(rules, &1)) end) |> join("|")
              "(" <> r <> ")"
          end
      end

    # IO.inspect({"resolved", name, r})

    r
  end

  def match_rule?(rules, rule_name, msg) do
    subrules = rules[rule_name]
    subrules |> map(fn rule_name -> resolve(rules, rule_name) end)
  end

  def parse_rule(rule) do
    [k, v] = String.split(rule, ":", trim: true)

    v =
      String.split(v, "|", trim: true)
      |> map(fn s ->
        String.split(s, " ", trim: true)
        |> map(fn x ->
          if x == k do
            "-1"
            x
          else
            x
          end
        end)
      end)

    # IO.inspect({k, v})
    {k, MapSet.new(v)}
  end

  def solve1(input) do
    {rules, messages} = read_input(input)

    pattern = resolve(rules, "0")
    {:ok, p} = Regex.compile("^" <> pattern <> "$")

    messages
    |> String.split("\n", trim: true)
    |> filter(fn s -> Regex.match?(p, s) end)
    |> length
  end

  def solve2(input) do
    {rules, messages} = read_input(input)

    p42 = resolve(rules, "42")
    p31 = resolve(rules, "31")
    p8r = "(#{p42})+"
    p11r = "(?<p11>#{p42}#{p31}|#{p42}(?&p11)?#{p31})"
    pattern = "#{p8r}#{p11r}"
    # IO.inspect({"final pattern", pattern})

    {:ok, p} = Regex.compile("^" <> pattern <> "$")

    messages
    |> String.split("\n", trim: true)
    |> filter(fn s -> Regex.match?(p, s) end)
    # |> IO.inspect
    |> length
  end
end

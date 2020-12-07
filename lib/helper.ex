defmodule Helper do
  def read_input_to_list_lines(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x -> String.strip(x) end)
  end
end

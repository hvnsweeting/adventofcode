defmodule Intcode do
  def state_to_int_list(state) do
    state |> String.split(",") |> Enum.map(fn s -> String.to_integer(String.trim(s)) end)
  end

  def compute(opcodes, position) do
    cond do
      Enum.at(opcodes, position) == 99 ->
        opcodes

      Enum.at(opcodes, position) == 1 ->
        opcodes =
          List.replace_at(
            opcodes,
            Enum.at(opcodes, position + 3),
            Enum.at(opcodes, Enum.at(opcodes, position + 1)) +
              Enum.at(opcodes, Enum.at(opcodes, position + 2))
          )

        compute(opcodes, position + 4)

      Enum.at(opcodes, position) == 2 ->
        opcodes =
          List.replace_at(
            opcodes,
            Enum.at(opcodes, position + 3),
            Enum.at(opcodes, Enum.at(opcodes, position + 1)) *
              Enum.at(opcodes, Enum.at(opcodes, position + 2))
          )

        compute(opcodes, position + 4)
    end
  end

  def run(state) do
    opcodes = state_to_int_list(state)
    compute(opcodes, 0)
  end
end

defmodule Intcode do
  def state_to_int_list(state) do
    state |> String.split(",") |> Enum.map(fn s -> String.to_integer(String.trim(s)) end)
  end

  @opcode_input_to 3
  @opcode_output_value 4
  @opcode_jump_if_true 5
  @param_position_mode 0
  @param_immediate_mode 1
  def compute(opcodes, position, input \\ 1) do
    oc = Enum.at(opcodes, position)
    # IO.inspect({"Opscodes", opcodes})
    # IO.inspect({"oc", oc, position})
    cond do
      Enum.at(opcodes, position) == 99 ->
        opcodes

      Enum.at(opcodes, position) == @opcode_input_to ->
        n = Enum.at(opcodes, position + 1)
        opcodes = List.replace_at(opcodes, n, input)
        compute(opcodes, position + 2)

      Enum.at(opcodes, position) == @opcode_output_value ->
        IO.inspect({"--output", Enum.at(opcodes, Enum.at(opcodes, position + 1))})
        compute(opcodes, position + 2)

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

      # Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      oc == @opcode_jump_if_true ->
        arg1 = Enum.at(opcodes, Enum.at(opcodes, position + 1))
        arg2 = Enum.at(opcodes, Enum.at(opcodes, position + 2))

        if arg1 != 0 do
          compute(opcodes, arg2)
        else
          compute(opcodes, position + 3)
        end

      # Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      oc == 6 ->
        arg1 = Enum.at(opcodes, Enum.at(opcodes, position + 1))
        arg2 = Enum.at(opcodes, Enum.at(opcodes, position + 2))

        if arg1 == 0 do
          compute(opcodes, arg2)
        else
          compute(opcodes, position + 3)
        end

      # Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      oc == 7 ->
        arg1 = Enum.at(opcodes, Enum.at(opcodes, position + 1))
        arg2 = Enum.at(opcodes, Enum.at(opcodes, position + 2))
        arg3 = Enum.at(opcodes, position + 3)

        if arg1 < arg2 do
          opcodes = List.replace_at(opcodes, arg3, 1)
          compute(opcodes, position + 4)
        else
          opcodes = List.replace_at(opcodes, arg3, 0)
          compute(opcodes, position + 4)
        end

      # Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      oc == 8 ->
        arg1 = Enum.at(opcodes, Enum.at(opcodes, position + 1))
        arg2 = Enum.at(opcodes, Enum.at(opcodes, position + 2))
        arg3 = Enum.at(opcodes, position + 3)

        if arg1 == arg2 do
          opcodes = List.replace_at(opcodes, arg3, 1)
          compute(opcodes, position + 4)
        else
          opcodes = List.replace_at(opcodes, arg3, 0)
          compute(opcodes, position + 4)
        end

      true ->
        param_opcode = Integer.to_string(Enum.at(opcodes, position))
        opcode = String.slice(param_opcode, -2, 2)

        param_modes =
          String.slice(param_opcode, 0, String.length(param_opcode) - 2)
          |> String.pad_leading(3, "0")
          |> String.to_charlist()

        modes = Enum.map(param_modes, fn x -> x - ?0 end)
        [marg1, marg2, marg3] = modes |> Enum.reverse()
        # map params mode with params, calculate
        arg1 = Enum.at(opcodes, position + 1)

        arg1 =
          if marg1 == @param_position_mode do
            Enum.at(opcodes, arg1)
          else
            arg1
          end

        arg2 = Enum.at(opcodes, position + 2)

        arg2 =
          if marg2 == @param_position_mode do
            Enum.at(opcodes, arg2)
          else
            arg2
          end

        arg3 = Enum.at(opcodes, position + 3)

        cond do
          opcode == "01" ->
            f = &(&1 + &2)
            opcodes = List.replace_at(opcodes, Enum.at(opcodes, position + 3), f.(arg1, arg2))
            compute(opcodes, position + 4)

          opcode == "02" ->
            f = &(&1 * &2)
            opcodes = List.replace_at(opcodes, Enum.at(opcodes, position + 3), f.(arg1, arg2))
            compute(opcodes, position + 4)

          opcode == "04" ->
            IO.inspect({"output", arg1})
            compute(opcodes, position + 2)

          opcode == "05" ->
            if arg1 != 0 do
              compute(opcodes, arg2)
            else
              compute(opcodes, position + 3)
            end

          opcode == "06" ->
            if arg1 == 0 do
              compute(opcodes, arg2)
            else
              compute(opcodes, position + 3)
            end

          opcode == "07" ->
            if arg1 < arg2 do
              opcodes = List.replace_at(opcodes, arg3, 1)
              compute(opcodes, position + 4)
            else
              opcodes = List.replace_at(opcodes, arg3, 0)
              compute(opcodes, position + 4)
            end

          opcode == "08" ->
            if arg1 == arg2 do
              opcodes = List.replace_at(opcodes, arg3, 1)
              compute(opcodes, position + 4)
            else
              opcodes = List.replace_at(opcodes, arg3, 0)
              compute(opcodes, position + 4)
            end

          true ->
            IO.inspect({"BUG", param_opcode, arg1, arg2, opcode, position})
            raise "99"
        end
    end
  end

  def run(state, input) do
    opcodes = state_to_int_list(state)
    compute(opcodes, 0, input)
  end
end

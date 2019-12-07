defmodule Intcode do
  def state_to_int_list(state) do
    state |> String.split(",") |> Enum.map(fn s -> String.to_integer(String.trim(s)) end)
  end

  @opcode_input_to 3
  @opcode_output_value 4
  @opcode_jump_if_true 5
  @param_position_mode 0
  @param_immediate_mode 1

  def get_value_in_position_mode(ns, index) do
    Enum.at(ns, Enum.at(ns, index))
  end

  def compute(opcodes, position, input \\ [], outputs \\ []) do
    oc = Enum.at(opcodes, position)
    # IO.inspect({"Opscodes", Enum.with_index(opcodes), "input", input, "output", outputs})
    # IO.inspect({"oc", oc, position})
    cond do
      oc == 99 ->
        {opcodes, outputs}

      oc == @opcode_input_to ->
        n = Enum.at(opcodes, position + 1)
        [h | t] = input
        opcodes = List.replace_at(opcodes, n, h)
        compute(opcodes, position + 2, t, outputs)

      oc == @opcode_output_value ->
        out = get_value_in_position_mode(opcodes, position + 1)
        compute(opcodes, position + 2, input, outputs ++ [out])

      oc == 1 ->
        opcodes =
          List.replace_at(
            opcodes,
            Enum.at(opcodes, position + 3),
            get_value_in_position_mode(opcodes, position + 1) +
              get_value_in_position_mode(opcodes, position + 2)
          )

        compute(opcodes, position + 4, input, outputs)

      oc == 2 ->
        opcodes =
          List.replace_at(
            opcodes,
            Enum.at(opcodes, position + 3),
            get_value_in_position_mode(opcodes, position + 1) *
              get_value_in_position_mode(opcodes, position + 2)
          )

        compute(opcodes, position + 4, input, outputs)

      # Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      oc == @opcode_jump_if_true ->
        arg1 = get_value_in_position_mode(opcodes, position + 1)
        arg2 = get_value_in_position_mode(opcodes, position + 2)

        if arg1 != 0 do
          compute(opcodes, arg2, input, outputs)
        else
          compute(opcodes, position + 3, input, outputs)
        end

      # Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
      oc == 6 ->
        arg1 = get_value_in_position_mode(opcodes, position + 1)
        arg2 = get_value_in_position_mode(opcodes, position + 2)

        if arg1 == 0 do
          compute(opcodes, arg2, input, outputs)
        else
          compute(opcodes, position + 3, input, outputs)
        end

      # Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      oc == 7 ->
        arg1 = get_value_in_position_mode(opcodes, position + 1)
        arg2 = get_value_in_position_mode(opcodes, position + 2)
        arg3 = Enum.at(opcodes, position + 3)

        if arg1 < arg2 do
          opcodes = List.replace_at(opcodes, arg3, 1)
          compute(opcodes, position + 4, input, outputs)
        else
          opcodes = List.replace_at(opcodes, arg3, 0)
          compute(opcodes, position + 4, input, outputs)
        end

      # Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      oc == 8 ->
        arg1 = get_value_in_position_mode(opcodes, position + 1)
        arg2 = get_value_in_position_mode(opcodes, position + 2)
        arg3 = Enum.at(opcodes, position + 3)

        if arg1 == arg2 do
          opcodes = List.replace_at(opcodes, arg3, 1)
          compute(opcodes, position + 4, input, outputs)
        else
          opcodes = List.replace_at(opcodes, arg3, 0)
          compute(opcodes, position + 4, input, outputs)
        end

      true ->
        param_opcode = Integer.to_string(oc)
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
            compute(opcodes, position + 4, input, outputs)

          opcode == "02" ->
            f = &(&1 * &2)
            opcodes = List.replace_at(opcodes, Enum.at(opcodes, position + 3), f.(arg1, arg2))
            compute(opcodes, position + 4, input, outputs)

          opcode == "04" ->
            compute(opcodes, position + 2, input, outputs ++ [arg1])

          opcode == "05" ->
            if arg1 != 0 do
              compute(opcodes, arg2, input, outputs)
            else
              compute(opcodes, position + 3, input, outputs)
            end

          opcode == "06" ->
            if arg1 == 0 do
              compute(opcodes, arg2, input, outputs)
            else
              compute(opcodes, position + 3, input, outputs)
            end

          opcode == "07" ->
            if arg1 < arg2 do
              opcodes = List.replace_at(opcodes, arg3, 1)
              compute(opcodes, position + 4, input, outputs)
            else
              opcodes = List.replace_at(opcodes, arg3, 0)
              compute(opcodes, position + 4, input, outputs)
            end

          opcode == "08" ->
            if arg1 == arg2 do
              opcodes = List.replace_at(opcodes, arg3, 1)
              compute(opcodes, position + 4, input, outputs)
            else
              opcodes = List.replace_at(opcodes, arg3, 0)
              compute(opcodes, position + 4, input, outputs)
            end

          true ->
            IO.inspect({"BUG", param_opcode, arg1, arg2, opcode, position})
            raise "99"
        end
    end
  end

  def run(state, input \\ [0]) do
    opcodes = state_to_int_list(state)
    {opcodes, _} = compute(opcodes, 0, input)
    opcodes
  end

  def check_output(state, input) do
    opcodes = state_to_int_list(state)
    {_, outputs} = compute(opcodes, 0, input)
    List.last(outputs)
  end
end

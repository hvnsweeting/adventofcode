defmodule Intcode do
  def state_to_int_list(state) do
    state |> String.split(",") |> Enum.map(fn s -> String.to_integer(String.trim(s)) end)
  end

  def state_to_int_map(state) do
    state
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.map(fn {v, idx} -> {idx, String.to_integer(String.trim(v))} end)
    |> Map.new()
  end

  def map_to_list(m) do
    m
    |> Map.to_list()
    |> Enum.sort(fn {k1, _}, {k2, _} -> k1 <= k2 end)
    |> Enum.map(fn {_, v} -> v end)
  end

  @opcode_input_to 3
  @opcode_output_value 4
  @opcode_jump_if_true 5
  @param_position_mode 0
  @param_immediate_mode 1
  @param_relative_mode 2

  def get_value_in_position_mode(ns, index) do
    ns[ns[index]] || 0
  end

  def compute(opcodes, position, input \\ [], outputs \\ [], relative_base \\ 0, parent \\ nil) do
    # oc = Map.get(opcodes, position)
    oc = opcodes[position]

    # IO.inspect({"oc", position})

    # IO.inspect(
    #   {"oc", oc, position, "input", input, "output", outputs, "relative_base", relative_base}
    # )

    if oc == 99 do
      if parent do
        send(parent, {:finish, self(), outputs})
      end

      {opcodes, outputs}
    else
      param_opcode = Integer.to_string(oc)

      {opcode, param_modes} =
        if String.length(param_opcode) == 1 do
          {"0" <> param_opcode, [?0, ?0, ?0]}
        else
          {String.slice(param_opcode, -2, 2),
           String.slice(param_opcode, 0, String.length(param_opcode) - 2)
           |> String.pad_leading(3, "0")
           |> String.to_charlist()}
        end

      modes = Enum.map(param_modes, fn x -> x - ?0 end)
      [marg1, marg2, marg3] = modes |> Enum.reverse()
      # IO.inspect({"Margs", [marg1, marg2, marg3]})
      # map params mode with params, calculate
      arg1 = Map.get(opcodes, position + 1)

      arg1 =
        cond do
          marg1 == @param_position_mode ->
            Map.get(opcodes, arg1) || 0

          marg1 == @param_relative_mode ->
            # IO.inspect({"relative_base", relative_base})
            Map.get(opcodes, arg1 + relative_base) || 0

          true ->
            arg1
        end

      arg2 = Map.get(opcodes, position + 2)

      arg2 =
        cond do
          marg2 == @param_position_mode -> Map.get(opcodes, arg2) || 0
          marg2 == @param_relative_mode -> Map.get(opcodes, arg2 + relative_base) || 0
          true -> arg2
        end

      # IO.inspect(
      #  {"oc", oc, position, "raw",
      #   {opcodes[position + 1], opcodes[position + 2], opcodes[position + 3]}, "arg1", arg1,
      #   "arg2", arg2, "relative_base", relative_base}
      # )

      cond do
        opcode == "01" ->
          f = &(&1 + &2)

          address =
            if marg3 == @param_relative_mode do
              opcodes[position + 3] + relative_base
            else
              opcodes[position + 3]
            end

          opcodes = Map.put(opcodes, address, f.(arg1, arg2))
          compute(opcodes, position + 4, input, outputs, relative_base, parent)

        opcode == "02" ->
          f = &(&1 * &2)

          address =
            if marg3 == @param_relative_mode do
              opcodes[position + 3] + relative_base
            else
              opcodes[position + 3]
            end

          opcodes = Map.put(opcodes, address, f.(arg1, arg2))
          compute(opcodes, position + 4, input, outputs, relative_base, parent)

        opcode == "03" ->
          input =
            if input == [] do
              receive do
                {:color, color} ->
                  # IO.inspect({"child received color", color})
                  [color]

                {src, signal} ->
                  [signal]

                e ->
                  IO.inspect({"ERROR", e})
                  raise "Child receive bad msg"
              end
            else
              input
            end

          [h | t] = input

          address =
            if marg1 == @param_relative_mode do
              opcodes[position + 1] + relative_base
            else
              opcodes[position + 1]
            end

          # IO.inspect({"Code 03 put input value", h, "to", address})
          opcodes = Map.put(opcodes, address, h)
          compute(opcodes, position + 2, t, outputs, relative_base, parent)

        opcode == "04" ->
          # note: reversed as we prepend list
          out = [arg1 | outputs]

          out =
            if parent do
              IO.inspect({"output from ", self(), out})
              [h | t] = out
              send(parent, {self(), h})
              []
            end

          # if parent && length(out) == 2 do
          #   [direction, color_to_paint] = out
          #   send(parent, {:day11, color_to_paint, direction})
          #   []
          # else
          #   out
          # end

          compute(opcodes, position + 2, input, out, relative_base, parent)

        opcode == "05" ->
          if arg1 != 0 do
            compute(opcodes, arg2, input, outputs, relative_base, parent)
          else
            compute(opcodes, position + 3, input, outputs, relative_base, parent)
          end

        opcode == "06" ->
          # IO.inspect({"Jump if false", arg1, arg2})

          if arg1 == 0 do
            compute(opcodes, arg2, input, outputs, relative_base, parent)
          else
            compute(opcodes, position + 3, input, outputs, relative_base, parent)
          end

        opcode == "07" ->
          address =
            if marg3 == @param_relative_mode do
              opcodes[position + 3] + relative_base
            else
              opcodes[position + 3]
            end

          if arg1 < arg2 do
            opcodes = Map.put(opcodes, address, 1)
            compute(opcodes, position + 4, input, outputs, relative_base, parent)
          else
            opcodes = Map.put(opcodes, address, 0)
            compute(opcodes, position + 4, input, outputs, relative_base, parent)
          end

        opcode == "08" ->
          address =
            if marg3 == @param_relative_mode do
              opcodes[position + 3] + relative_base
            else
              opcodes[position + 3]
            end

          if arg1 == arg2 do
            opcodes = Map.put(opcodes, address, 1)
            compute(opcodes, position + 4, input, outputs, relative_base, parent)
          else
            opcodes = Map.put(opcodes, address, 0)
            compute(opcodes, position + 4, input, outputs, relative_base, parent)
          end

        opcode == "09" ->
          # IO.inspect({"relative add", relative_base, arg1})
          compute(opcodes, position + 2, input, outputs, relative_base + arg1, parent)

        true ->
          IO.inspect({"BUG", param_opcode, arg1, arg2, opcode, position})
          raise "99"
      end
    end
  end

  def run(state, input \\ [0]) do
    opcodes = state_to_int_map(state)
    {opcodes, _} = compute(opcodes, 0, input)
    opcodes
  end

  def check_output(state, input) do
    # opcodes = state_to_int_list(state)
    opcodes = state_to_int_map(state)
    {_, outputs} = compute(opcodes, 0, input)
    outputs = Enum.reverse(outputs)
    List.last(outputs)
  end

  def check_raw_output(state, input, parent \\ nil) do
    # opcodes = state_to_int_list(state)
    opcodes = state_to_int_map(state)
    {_, outputs} = compute(opcodes, 0, input, [], 0, parent)
    outputs = Enum.reverse(outputs)
    outputs
  end
end

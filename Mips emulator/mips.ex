defmodule Main do

  def main() do
    code =
      [
        {:addi, 1, 0, 5},     # $1 <- 5
        {:lw, 2, 0, :arg},    # $2 <- data[:arg]
        {:add, 4, 2, 1},      # $4 <- $2 + $1
        {:addi, 5, 0, 1},     # $5 <- 1
        {:label, :loop},
        {:sub, 4, 4, 5},      # $4 <- $4 - $5
        {:out, 4},            # out $4
        {:bne, 4, 0, :loop},  # branch if not equal
        :halt
      ]
    data = [{:arg, 12}]
    Emulator.run({:prgm, code, data})
  end
end

defmodule Emulator do

  def run(prgm) do
    {code, data} = Program.load(prgm)
    out = Out.new()
    reg = Register.new()
    run(0, code, reg, data, out)
  end

  def run(pc, code, reg, mem, out) do
    next = Program.read_instruction(code, pc)
    case next do
        :halt ->
          Out.close(out)

        {:out, rs} ->
          pc = pc + 4
          s = Register.read(reg, rs)
          out = Out.put(out, s)
          run(pc, code, reg, mem, out)

        {:add, rd, rs, rt} ->
          pc = pc + 4
          s = Register.read(reg, rs)
          t = Register.read(reg, rt)
          reg = Register.write(reg, rd, s + t)
          run(pc, code, reg, mem, out)

        {:sub, rd, rs, rt} ->
          pc = pc + 4
          s = Register.read(reg, rs)
          t = Register.read(reg, rt)
          reg = Register.write(reg, rd, s - t)
          run(pc, code, reg, mem, out)

        {:addi, rd, rt, imm} ->
          pc = pc + 4
          t = Register.read(reg, rt)
          reg = Register.write(reg, rd, t + imm)
          run(pc, code, reg, mem, out)

        {:lw, rd, _, offset} ->
          pc = pc + 4
          val = Program.read_data(mem, offset)
          reg = Register.write(reg, rd, val)
          run(pc, code, reg, mem, out)

        {:sw, rt, rs, offset} ->
          pc = pc + 4
          s = Register.read(reg, rs)
          t = Register.read(reg, rt)
          addr = t + offset
          data = Register.write_data(mem, addr, s)
          run(pc, code, reg, mem, out)

        {:bne, rs, rt, offset} ->
          pc = pc + 4
          s = Register.read(reg, rs)
          t = Register.read(reg, rt)
          cond do
            s != t ->
              pc = Program.read_data(mem, offset)
              run(pc, code, reg, mem, out)
            s == t ->
              run(pc, code, reg, mem, out)
          end

        {:label, label} ->
          pc = pc + 4
          mem = Program.write_data(mem, label, pc)
          run(pc, code, reg, mem, out)
    end
  end
end

defmodule Out do

  def new() do  [] end

  def put(out, a) do
    [a|out]
  end

  def close(lst) do
    IO.write("List: ")
    Enum.reverse(lst)
  end

end

defmodule Program do

  def load({:prgm, code, data}) do {code, data} end

  def read_instruction([instruction|tail], pc) do
    case pc do
      0 -> instruction
      _-> read_instruction(tail, pc-4)
    end
  end

  def read_data([{ket,val}|_], key) do val end
  def read_data([_|tail]) do read_data(tail) end

  def write_data([], key, value) do [{key, value}] end
  def write_data(data, key, value) do [{key, value}|data] end

end

defmodule Register do

  #creates 32 numbers to represent registers with index from 0-31
  def new() do
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  end

  #if 0 register return 0
  def read(  _, 0) do 0 end

  #return value of register with index i
  def read(reg, i) do elem(reg, i) end

  #if writing with one being reg zero simply writes the reg value
  def write(reg, 0, _) do reg end

  #writes value to reg with index i
  def write(reg, i, val) do put_elem(reg, i, val) end

end

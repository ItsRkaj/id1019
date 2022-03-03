defmodule Test do
  def test(l1, l2) do
    instr = Shunt.compress(Shunt.few(l1, l2))
    IO.inspect(instr)
    IO.write("\n")
    Moves.move(instr, {l1, [], []})
  end

  def t(l1, l2) do
    Moves.move(Shunt.compress(Shunt.few(l1, l2)), {l1, [], []})
  end
end

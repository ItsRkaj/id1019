defmodule Shunt do
  def find([], []) do [] end
  def find(train, [h|t]) do
    {l1, l2} = split(train, h)
    [{:one, Enum.count(l2) + 1}, {:two, Enum.count(l1)}, {:one, -(Enum.count(l2) + 1)}, {:two, -(Enum.count(l1))}|find(Commands.append(l1, l2), t)]
  end

  def few([], []) do [] end
  def few([hx|tx], [hy|ty]) do
    {l1, l2} = split([hx|tx], hy)
    cond do
      hx == hy -> few(tx, ty)
      true -> [{:one, Enum.count(l2) + 1}, {:two, Enum.count(l1)}, {:one, -(Enum.count(l2) + 1)}, {:two, -(Enum.count(l1))}|find(Commands.append(l1, l2), ty)]
    end
  end

  def split(l, e) do
    {Commands.take(l, Commands.position(l, e) - 1), Commands.drop(l, Commands.position(l, e))}
  end

  def comp([]) do [] end
  def comp([{_, 0}]) do [] end
  def comp([{move1, m}]) do [{move1, m}] end
  def comp([{move1, m}, {move2, n}|t]) do
    cond do
      move1 == move2 -> comp([{move1, m+n}|t])
      m == 0 -> comp([{move2, n}|t])
      true -> [{move1, m}|comp([{move2, n}|t])]
    end
  end

  def compress(ms) do
    ns = comp(ms)
    cond do
      ns == ms -> ms
      true     -> compress(ns)
    end
  end
end

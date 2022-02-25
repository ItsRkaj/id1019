defmodule Commands do
  def take([], _) do [] end
  def take(_, 0) do [] end
  def take([h|t], n) do [h|take(t, n-1)] end

  def drop(l, 0) do l end
  def drop([_|t], n) do drop(t, n-1) end

  def append(l, []) do l end
  def append(list, [h2|t2]) do append(list ++ [h2],t2) end

  def member([], _) do false end
  def member([h|t], e) do
    cond do
      h == e -> true
      true -> member(t, e)
    end
  end

  def position(l, e) do position(l, e, 0) end
  def position([h|t], e, i) do
    cond do
      h == e -> i+1
      true -> position(t, e, i+1)
    end
  end

end

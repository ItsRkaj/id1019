defmodule Train do

  def take([], 0) do [] end
  def take([h|t], n) do [h|take(t, n-1)] end

  def drop([h|t], 0) do [h|t] end
  def drop([h|t], n) do drop(t, n-1) end

  def append([h|t], [h2|t2]) do [h|t] ++ [h2|t2] end

  def member([], []) do  end

  def position([], []) do  end
end

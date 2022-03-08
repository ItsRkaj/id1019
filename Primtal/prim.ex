defmodule Prim do

  #First solution
  def siev1([]) do [] end
  def siev1([h|t]) do [h|siev1(t -- Enum.filter(t, fn(x) -> rem(x, h) == 0 end))] end

  #Second solution
  def siev2(l) do siev2(l, []) end
  def siev2([h|t], []) do siev2(t, [h]) end
  def siev2([], prim) do prim end
  def siev2([h|t], prim) do siev2(t, div_siev2(h, prim)) end

  def div_siev2(e, p) do
    case p do
      [h|[]] -> cond do
        rem(e,h) != 0 -> [h,e]
        true -> [h]
      end
      [h|t] -> cond do
        rem(e,h) != 0 -> [h|div_siev2(e, t)]
        true -> [h|t]
      end
    end
  end

  #Third solution
  def find_prime3(list) do
    reverse(find_prime3(list, []), [])
  end
  def find_prime3([], primes) do
    primes
  end
  def find_prime3([h | t], []) do
    find_prime3(t, [h])
  end
  def find_prime3([h | t], primes) do
    find_prime3(t, div_prime3(h, primes, primes))
  end
  def div_prime3(e, [h | []], primes) do
    cond do
      rem(e, h) != 0 -> [e | primes]
      true -> primes
    end
  end
  def div_prime3(e, [h | t], primes) do
    cond do
      rem(e, h) != 0 -> div_prime3(e, t, primes)
      true -> primes
    end
  end
  def reverse([], l) do l end
  def reverse([h | t], l) do
    reverse(t, [h | l])
  end

  def bench() do
    ls = [1024, 2048, 4*1024, 8*1024, 16*1024, 32*1024, 64*1024, 128*1024, 256*1024, 512*1024]
    bench(ls)
  end
  def bench([h | t]) do
    IO.write("  #{prime1(h)}\t\t\t#{prime2(h)}\t\t\t#{prime3(h)}\n")
    case t do
      [] -> :ok
      _ -> bench(t)
    end
  end

  def prime1(n) do
    lists = Enum.to_list(2..n)
    {uSecs, :ok} = :timer.tc( fn  -> siev1(lists)
                              :ok end)
    uSecs
  end
  def prime2(n) do
    lists = Enum.to_list(2..n)
    {uSecs, :ok} = :timer.tc( fn  -> siev2(lists)
                              :ok end)
    uSecs
  end
  def prime3(n) do
    lists = Enum.to_list(2..n)
    {uSecs, :ok} = :timer.tc( fn  -> find_prime3(lists)
                              :ok end)
    uSecs
  end
end

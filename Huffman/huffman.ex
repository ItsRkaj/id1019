defmodule Huffman do

  def bench() do
    texts = [text(), sample(), read("kallocain.txt")]
    IO.write("#{bench(text())}#{bench(read("kallocain.txt"))}")
  end

  def bench(h) do
    sample = h
    {treetime, :ok} = :timer.tc(fn -> tree(sample)
    :ok end)
    tree = tree(sample)
    {encodetime, :ok} = :timer.tc(fn -> encode_table(tree)
    :ok end)
    encode = encode_table(tree)
    {decodetabletime, :ok} = :timer.tc(fn -> decode_table(tree)
    :ok end)
    decode = decode_table(tree)
    text = h
    {sequencetime, :ok} = :timer.tc(fn -> encrypt(text, encode)
    :ok end)
    seqence = encrypt(text, encode)
    {decodetime, :ok} = :timer.tc(fn -> decode(seqence, decode)
    :ok end)
    readable = decode(seqence, decode)
    IO.write("number of characters: #{Enum.count(h)}\ntime to create tree: #{treetime}\ntime to encode table: #{encodetime}\ntime to decode table: #{decodetabletime}\ntime to encode text: #{sequencetime}\ntime to decode sequence: #{decodetime}\n\n")
    :ok
  end

  def time(text) do
    {uSecs, :ok} = :timer.tc(fn -> test(text)
    :ok end)
    uSecs
  end

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test(input) do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    seq = encrypt(sample, encode)
    decode = decode_table(tree)
    text = input
    seqence = encrypt(text, encode)
    decode(seqence, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def encode_table(tree) do
    sortway(way(tree, [], []), [])
  end

  def decode_table(tree) do
    way(tree, [], [])
  end

  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} -> {char, rest}
      nil -> decode_char(seq, n+1, table)
    end
  end

  def encrypt([], _) do
    []
  end
  def encrypt([h | t], way) do
    findway(h, way) ++ encrypt(t, way)
  end

  def findway(ch, [{ch, path} | _]) do
    path
  end
  def findway(ch, [_ | t]) do
    findway(ch, t)
  end

  def way({left, right}, track, n) do
    l = way(left, [0 | track], n)
    way(right, [1 | track], l)
  end
  def way(e, track, n) do
    [{e, reverse(track, [])} | n]
  end

  def reverse([], l) do
    l
  end
  def reverse([h | t], l) do
    reverse(t, [h | l])
  end

  def sortway([], list) do
    list
  end
  def sortway([h | t], list) do
    sortway(t, insertway(h, list))
  end

  def insertway(e, []) do
    [e]
  end
  def insertway({e, val}, [{he, hval} | t]) do
    cond do
      Enum.count(val) < Enum.count(hval) -> [{e, val}, {he, hval} | t]
      true -> [{he, hval} | insertway({e, val}, t)]
    end
  end

  def freq(list) do
    freq(list, [])
  end
  def freq([], fr) do
    fr
  end
  def freq([h | t], fr) do
    freq(t, member(h, fr))
  end

  def member(e, []) do
    [{e, 1}]
  end
  def member(e, [{e, n} | t]) do
    [{e, n+1} | t]
  end
  def member(e, [h | t]) do
    [h | member(e, t)]
  end

  def huffman(list) do
    huffmansort(sort(list, []))
  end

  def huffmansort([{tree, _}]) do
    tree
  end
  def huffmansort([{h1, v1}, {h2, v2} | t]) do
    huffmansort(add({{h1, h2}, v1 + v2}, t))
  end

  def add({e, val}, []) do
    [{e, val}]
  end
  def add({e, v1}, [{h, v2} | t]) do
    cond do
      v1 < v2 -> [{e, v1}, {h, v2} | t]
      true -> [{h, v2} | add({e, v1}, t)]
    end
  end

  def sort([], list) do
    list
  end
  def sort([h | t], list) do
    sort(t, insert(h, list))
  end

  def insert(e, []) do
    [e]
  end
  def insert({e, val}, [{he, hval} | t]) do
    cond do
      val < hval -> [{e, val}, {he, hval} | t]
      true -> [{he, hval} | insert({e, val}, t)]
    end
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)

    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} -> list
      list -> list
    end
  end

end

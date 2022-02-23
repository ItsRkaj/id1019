defmodule Test do

  #Uppgift 2
  def double(n) do
    n * 2
  end

  def farToCel(n) do
    (n - 32)/1.8
  end

  def areaOfRec(b, h) do
    b * h
  end

  def areaOfSquare(n) do
    n * n
  end

  def areaOfCircle(r) do
    r * r * :math.pi()
  end


  #Uppgift 3
  def product(m, n) do
    if m == 0 do
      0
    else
      n + product(m-1, n)
    end
  end

  def product_case(m, n) do
    case m do
    0 -> 0
    _ -> n + product_case(m-1, n)
    end
  end

  def product_cond(m, n) do
    cond do
      m == 0 -> 0
      true -> n + product_cond(m-1, n)
    end
  end

  def product_clauses(0, _) do 0 end
  def product_clauses(m, n) do
    product_clauses(m-1, n) + n
  end

  def exp(x, n) do
    case n do
        1 -> x
        _ ->
            case rem(n, 2) do
              0 -> product(exp(x, div(n, 2)), exp(x, div(n, 2)))
              1 -> product(x, exp(x, n - 1))
            end
    end
  end

  #Uppgift 4
  def len(x) do
    cond do
        x === [] -> 0
        true ->
            [head | tail] = x # can replace head with _
            len(tail, 0)
    end
  end

  def len(x, counter) do
      new_counter = counter + 1 # counter can be replaced with
      cond do
          x === [] -> new_counter
          # x == nil -> new_counter (this fails)
          true ->
              [head | tail] = x
              len(tail, new_counter)
      end
  end

  def sum(x) do
      cond do
          x === [] -> 0
          true ->
              [head | tail] = x
              head + sum(tail)
      end
  end

  def duplicate(x) do
      cond do
          x === [] -> x
          true ->
              [head | tail] = x
              [head | [head | duplicate(tail)]]
      end
  end

  def duplicate_1([head | tail], []) do
      duplicate_1(tail, [head, head])
  end

  def duplicate_1([head | tail], dList) do
      duplicate_1(tail, dList ++ [head, head])
  end
  def duplicate_1([], dList) do
      dList
  end

  def duplicate_2(list) do
      duplicate_2(list, [])
  end

  def duplicate_2([head|tail], list) do
      duplicate_2(tail, list++[head, head])
  end

  def duplicate_2([], list) do
      list
  end

  def duplicate_3(l) do
      [h|t] = l
      case t do
          [] -> [h, h]
          _ -> [h, h] ++ duplicate_3(t)
      end
  end

  def add(element, list) do
      cond do
          list === [] -> []
          true -> [h | t] = list
              cond do
                  h === element -> list
                  true -> [h] ++ add(element, t, false)
                  # true -> [h | add(element, t, false)] also works
              end
      end
  end

  def add(element, list, boolean) do
      cond do
          boolean === true -> []
          true ->
              cond do
                  list === [] -> element
                  true ->
                      [h | t] = list
                      if h === element do
                          [h | add(element, t, true)]
                      else
                          [h] ++ [add(element, t, false)]
                      end
              end
      end
  end

  def remove(_, []) do
      []
  end

  def remove(element, list) do
      [h | t] = list
      cond do
          element === h -> remove(element, t)
          true -> [h | remove(element, t)]
      end
      #case h do
      #    element -> remove(element, t)
      #    _ -> [h | remove(element, t)]
      #end
  end

  def unique([]) do
      []
  end
  def unique([head | tail]) do
      [head] ++ unique(remove(head, tail))
  end

  def reverse(list) do
      case list do
          [] -> list
          _ ->
              [h | t] = list
              reverse(t) ++ [h]
      end
  end

  def insert(element, []) do
    [element]
  end

  def insert(element, list) do
      [head | tail] = list
      cond do
          element < head -> [element] ++ list
          element > head -> [head] ++ insert(element, tail)
      end
  end

  def isort(l) do
      isort(l, [])
  end

  def isort(x, l) do
      case x do
          [] ->
              l
          [h | t] when h < x ->
              isort(t, insert(h, l))
          [h | t] ->
              isort(t, insert(h, l))
      end
  end

  def insert_sort(l) do
      insert_sort(l, [])
  end
  def insert_sort([], sort) do
      sort
  end
  def insert_sort(l, sort) do
      [head | tail] = l
      insert_sort(tail, insert(head, sort))
  end

  def insort(l) do
      insort(l, [])
  end

  def insort([head|tail], list) do
      list = insert(head,list)
      insort(tail, list)
  end

  def insort([], list) do
      list
  end

  def msort(l) do
      case length(l) do
          len when len < 2 ->
              # IO.puts "msort1"
              l
          _ ->
              # IO.puts "msort2"
              {split1, split2} = msplit(l, [], [])
              # IO.puts split1
              # IO.puts split2
              merge(msort(split1), msort(split2))
      end
  end

  def merge([], l) do l end
  def merge(l, []) do l end
  def merge(list1, list2) do
      [head1 | tail1] = list1
      [head2 | tail2] = list2
      if head1 < head2 do
          # IO.puts "merge1"
          # merge(list1 ++ list2, [])
          # new_list = [head1 | head2]
          [head1] ++ merge(tail1, list2)
      else
          # IO.puts "merge2"
          [head2] ++ merge(list1, tail2)
      end
  end

  def msplit(list, split1, split2) do
      case length(list) do
      len when len < 2 ->
          # IO.puts "msplit1"
          {split1, list ++ split2}
      _ ->
          # IO.puts "msplit2"
          [head | tail] = list
          [head1 | tail1] = tail
          msplit(tail1, [head | split1], [head1 | split2])
      end
  end

end

defmodule Moves do
  def single({track, wagon}, {list_main, list_track1, list_track2}) do
    case track do
      :one -> cond do
        wagon > 0 ->
          {Commands.take(list_main, Enum.count(list_main) - wagon),
          Commands.append(Commands.drop(list_main, Enum.count(list_main) - wagon), list_track1),
          list_track2}
        wagon < 0 ->
          {Commands.append(list_main, Commands.take(list_track1, -wagon)),
          Commands.drop(list_track1, -wagon),
          list_track2}
        true -> {list_main, list_track1, list_track2}
      end
      :two -> cond do
        wagon > 0 ->
          {Commands.take(list_main, Enum.count(list_main) - wagon),
          list_track1,
          Commands.append(Commands.drop(list_main, Enum.count(list_main) - wagon), list_track2)}
        wagon < 0 ->
          {Commands.append(list_main, Commands.take(list_track2, -wagon)),
          list_track1,
          Commands.drop(list_track2, -wagon)}
        true -> {list_main, list_track1, list_track2}
      end
    end
  end

  def move([], state) do [state] end
  def move([h|t], state) do
    [state|move(t, single(h, state))]
  end
end

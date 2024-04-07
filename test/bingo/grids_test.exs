defmodule Bingo.GridsTest do
  use ExUnit.Case

  alias Bingo.Grids

  test "new_grid/0 returns a randomized 5x5 grid of tuples, initialized to false" do
    assert [
             [{_, false}, {_, false}, {_, false}, {_, false}, {_, false}],
             [{_, false}, {_, false}, {_, false}, {_, false}, {_, false}],
             [{_, false}, {_, false}, {_, false}, {_, false}, {_, false}],
             [{_, false}, {_, false}, {_, false}, {_, false}, {_, false}],
             [{_, false}, {_, false}, {_, false}, {_, false}, {_, false}]
           ] = Grids.new_grid()
  end

  test "toggle_cell/3 toggles the value of the cell at the given row and column" do
    grid = Grids.new_grid()

    assert [{_, false}, {_, false}, {_, true}, {_, false}, {_, false}] =
             Grids.toggle_cell(grid, 0, 2) |> Enum.at(0)
  end

  test "shuffle_by_date/2 shuffles a list of strings based on the day of the year" do
    list = ["a", "b", "c", "d", "e"]
    shuffled = Grids.shuffle_by_date(list, ~D[2021-01-01])

    assert has_same_elements(shuffled, list)
    assert shuffled != list
  end

  test "shuffle_by_date/2 returns the same shuffled list for the same date" do
    list = ["a", "b", "c", "d", "e"]
    shuffled1 = Grids.shuffle_by_date(list, ~D[2021-01-01])
    shuffled2 = Grids.shuffle_by_date(list, ~D[2021-01-01])

    assert shuffled1 == shuffled2
  end

  test "shuffle_by_date/2 returns different shuffled lists for different dates" do
    list = ["a", "b", "c", "d", "e"]
    shuffled1 = Grids.shuffle_by_date(list, ~D[2021-01-01])
    shuffled2 = Grids.shuffle_by_date(list, ~D[2021-01-02])

    assert shuffled1 != shuffled2
  end

  defp has_same_elements(list1, list2) do
    Enum.all?(list1, fn x -> Enum.member?(list2, x) end) && length(list1) == length(list2)
  end
end

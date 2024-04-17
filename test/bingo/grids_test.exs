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
end

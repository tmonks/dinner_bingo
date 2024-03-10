defmodule Bingo.Grids do
  @moduledoc """
  module for working with bingo grids
  """

  @doc """
  Creates a new 5x5, true/false grid mask
  """
  def new_grid do
    # get random cells, and create a 5x5 grid
    get_random_cells()
    |> Enum.chunk_every(5)
    |> Enum.map(fn row ->
      Enum.map(row, fn cell -> {cell, false} end)
    end)
  end

  @doc """
  toggles the true/false value of the specified cell in the grid
  """
  def toggle_cell(grid, row_index, col_index) do
    # get the original row
    row = Enum.at(grid, row_index)
    # get the original cell
    {cell_text, cell_value} = Enum.at(row, col_index)
    # update the row with the new cell
    row = replace_at(row, col_index, {cell_text, !cell_value})
    # update the grid with the new row
    replace_at(grid, row_index, row)
  end

  defp replace_at(list, index, value) do
    Enum.with_index(list)
    |> Enum.map(fn {el, i} -> if i == index, do: value, else: el end)
  end

  defp get_random_cells do
    # return 25 random cells
    cells()
    |> Enum.take_random(25)
  end

  defp cells do
    [
      "Learned something interesting",
      "Had something funny happen to them",
      "Did something embarrassing",
      "made someone laugh",
      "did something kind for someone",
      "tried a new food",
      "got a new idea they're excited about",
      "had an encounter with an animal",
      "Solved a problem",
      "Received a compliment",
      "Helped a friend or colleague",
      "Learned a new word or phrase",
      "Faced a fear",
      "Noticed something beautiful",
      "Made a new friend or acquaintance",
      "Completed a goal or task",
      "Had a moment of relaxation",
      "Experienced a moment of gratitude",
      "Observed an act of kindness",
      "Learned from a mistake",
      "Felt inspired by something or someone",
      "Saw something new on their way to school/work",
      "Tried a new activity",
      "Had a meaningful conversation",
      "Overcame a challenge",
      "Changed an opinion about something",
      "Found something lost or thought was gone",
      "Shared a favorite moment of the day"
    ]
  end
end

defmodule Bingo.GridServerTest do
  use ExUnit.Case, async: true

  alias Bingo.GridServer

  setup do
    server = start_supervised!(GridServer)
    %{server: server}
  end

  test "can ping the server", %{server: server} do
    assert GridServer.ping(server) == :pong
  end

  test "can retrieve a grid", %{server: server} do
    assert grid = GridServer.get_grid(server)
    assert length(grid) == 5
    assert Enum.at(grid, 0) |> length() == 5
  end

  test "can toggle a grid cell", %{server: server} do
    grid = GridServer.get_grid(server)

    # initially false
    assert {cell_text, false} = get_cell(grid, 0, 0)

    assert returned_grid = GridServer.toggle(server, 0, 0)

    assert {^cell_text, true} = get_cell(returned_grid, 0, 0)
    assert {^cell_text, true} = GridServer.get_grid(server) |> get_cell(0, 0)
  end

  defp get_cell(grid, row, col) do
    Enum.at(grid, row) |> Enum.at(col)
  end
end

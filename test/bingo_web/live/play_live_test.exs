defmodule BingoWeb.PlayLiveTest do
  use BingoWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders a title", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")

    assert html =~ "Bingo"
  end

  test "renders a 5x5 grid", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#cell-0-0")
    assert has_element?(view, "#cell-4-4")
  end
end

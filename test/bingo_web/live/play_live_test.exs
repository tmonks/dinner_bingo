defmodule BingoWeb.PlayLiveTest do
  use BingoWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  test "renders a title", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "Bingo"
  end

  test "renders a 5x5 grid", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#cell-0-0")
    assert has_element?(view, "#cell-4-4")
  end

  test "can click a cell and toggle its status", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#cell-0-0[data-status=false]")

    view |> element("#cell-0-0") |> render_click()

    assert has_element?(view, "#cell-0-0[data-status=true]")
  end

  test "refreshing the page does not reset the grid", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # toggle the first cell
    view |> element("#cell-0-0") |> render_click()
    assert has_element?(view, "#cell-0-0[data-status=true]")

    # Refresh the page
    {:ok, view, _html} = live(conn, "/")
    assert has_element?(view, "#cell-0-0[data-status=true]")
  end

  test "clicking the 'New Game' button resets with a new grid", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # toggle the first cell
    view |> element("#cell-0-0") |> render_click()
    assert has_element?(view, "#cell-0-0[data-status=true]")

    # Click the 'New Game' button
    view |> element("#new-game") |> render_click()

    assert has_element?(view, "#cell-0-0[data-status=false]")
  end

  test "pushes 'store' event when a cell is toggled", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view |> element("#cell-0-0") |> render_click()

    assert_push_event(view, "store", %{key: "dinner-bingo"})
  end
end

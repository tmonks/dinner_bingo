defmodule BingoWeb.PlayLive do
  use BingoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    grid = Bingo.Grids.new_grid()
    {:ok, assign(socket, grid: grid)}
  end

  @impl true
  def handle_event("toggle", %{"row" => row, "col" => col}, socket) do
    row = String.to_integer(row)
    col = String.to_integer(col)

    grid = socket.assigns.grid |> Bingo.Grids.toggle_cell(row, col)

    {:noreply, assign(socket, grid: grid)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Bingo</h1>
    <div style="display: flex; flex-direction: column; flex-gap: 1em; width: 600; height: 600">
      <%= for {row, r} <- Enum.with_index(@grid) do %>
        <div style="display: flex; flex-direction: row; height: 100px">
          <%= for {{text, status}, c} <- Enum.with_index(row) do %>
            <div
              id={"cell-#{r}-#{c}"}
              style="border: 1px solid black; width: 200px; text-align: center;"
              data-status={"#{status}"}
              phx-click="toggle"
              phx-value-row={r}
              phx-value-col={c}
              class={get_classes_for_status(status)}
            >
              <%= text %>
            </div>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp get_classes_for_status(true), do: "bg-red-400"
  defp get_classes_for_status(_), do: "bg-blue-400"
end

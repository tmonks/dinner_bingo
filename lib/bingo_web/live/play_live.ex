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
    <h1 class="text-3xl text-center mb-2">Dinner Bingo</h1>
    <div class="flex flex-col gap-1 w-full md:max-w-xl mx-auto">
      <%= for {row, r} <- Enum.with_index(@grid) do %>
        <div class="flex flex-row gap-1 max-h-">
          <%= for {{text, status}, c} <- Enum.with_index(row) do %>
            <div
              id={"cell-#{r}-#{c}"}
              style="width: 200px; text-align: center;"
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

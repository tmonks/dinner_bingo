defmodule BingoWeb.PlayLive do
  use BingoWeb, :live_view

  alias Bingo.GridServer

  @impl true
  def mount(_params, _session, socket) do
    grid = GridServer.get_grid(:grid_server)
    {:ok, assign(socket, grid: grid)}
  end

  @impl true
  def handle_event("toggle", %{"row" => row, "col" => col}, socket) do
    row = String.to_integer(row)
    col = String.to_integer(col)

    # grid = socket.assigns.grid |> Bingo.Grids.toggle_cell(row, col)
    grid = GridServer.toggle(:grid_server, row, col)

    {:noreply, assign(socket, grid: grid)}
  end

  @impl true
  def handle_event("new_game", _params, socket) do
    grid = GridServer.new_grid(:grid_server)
    {:noreply, assign(socket, grid: grid)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl text-center mb-2">Dinner Bingo</h1>
    <div class="grid grid-cols-5 gap-1 w-full sm:max-w-xl mx-auto">
      <%= for {row, r} <- Enum.with_index(@grid) do %>
        <%= for {{text, status}, c} <- Enum.with_index(row) do %>
          <div
            id={"cell-#{r}-#{c}"}
            data-status={"#{status}"}
            phx-click="toggle"
            phx-value-row={r}
            phx-value-col={c}
            class={get_classes_for_status(status) <> " h-28 p-1 flex justify-center items-center text-center text-xs sm:text-sm overflow-hidden cursor-pointer"}
          >
            <%= text %>
          </div>
        <% end %>
      <% end %>
    </div>
    <div class="text-center">
      <button id="new-game" phx-click="new_game" class="bg-blue-500 text-white p-2 mt-4">
        New Game
      </button>
    </div>
    """
  end

  defp get_classes_for_status(true), do: "bg-green-300"
  defp get_classes_for_status(_), do: "bg-indigo-400"
end

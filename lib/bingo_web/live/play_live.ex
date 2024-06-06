defmodule BingoWeb.PlayLive do
  use BingoWeb, :live_view
  require Logger

  alias Bingo.GridServer

  @storage_key "dinner-bingo"

  @impl true
  def mount(_params, _session, socket) do
    socket =
      if connected?(socket) do
        push_event(socket, "restore", %{key: @storage_key, event: "restoreSettings"})
      else
        socket
      end

    {:ok,
     socket
     |> assign(grid: nil)
     |> assign(storage_key: @storage_key)}
  end

  @impl true
  def handle_event("toggle", %{"row" => row, "col" => col}, socket) do
    row = String.to_integer(row)
    col = String.to_integer(col)

    grid = GridServer.toggle(:grid_server, row, col)

    {:noreply,
     socket
     |> assign(grid: grid)
     |> push_event("store", %{key: socket.assigns.storage_key, data: serialize_to_token(grid)})}
  end

  @impl true
  def handle_event("new_game", _params, socket) do
    socket = socket |> get_new_grid()
    {:noreply, socket}
  end

  @impl true
  # Pushed from JS hook.
  def handle_event("restoreSettings", token_data, socket) when is_binary(token_data) do
    IO.puts("restoreSettings event received...")

    socket =
      case restore_from_token(token_data) do
        {:ok, nil} ->
          socket

        {:ok, restored_grid} ->
          assign(socket, grid: restored_grid)

        {:error, reason} ->
          socket
          |> put_flash(:error, reason)

          # |> clear_browser_storage()
      end

    {:noreply, socket}
  end

  def handle_event("restoreSettings", _token_data, socket) do
    IO.puts("restoreSettings event received with no data :-(")
    socket = get_new_grid(socket)
    {:noreply, socket}
  end

  def get_new_grid(socket) do
    IO.puts("Generating new grid...")
    grid = GridServer.new_grid(:grid_server)

    socket
    |> assign(grid: grid)
    |> push_event("store", %{key: socket.assigns.storage_key, data: serialize_to_token(grid)})
  end

  defp serialize_to_token(state_data) do
    salt = Application.get_env(:bingo, BingoWeb.Endpoint)[:live_view][:signing_salt]
    Phoenix.Token.encrypt(BingoWeb.Endpoint, salt, state_data)
  end

  defp restore_from_token(token) do
    salt = Application.get_env(:bingo, BingoWeb.Endpoint)[:live_view][:signing_salt]

    case Phoenix.Token.decrypt(BingoWeb.Endpoint, salt, token) do
      {:ok, data} ->
        {:ok, data}

      {:error, reason} ->
        {:error, "Failed to restore previous state. Reason: #{inspect(reason)}."}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="container" phx-hook="LocalStateStore">
      <h1 class="text-3xl text-center mb-2">Dinner Bingo</h1>
      <%= if is_nil(@grid) do %>
        <div class="text-center text-2xl pt-12">Loading...</div>
      <% else %>
        <div id="bingo-grid" class="grid grid-cols-5 gap-1 w-full sm:max-w-xl mx-auto">
          <%= for {row, r} <- Enum.with_index(@grid) do %>
            <%= for {{text, status}, c} <- Enum.with_index(row) do %>
              <div
                id={"cell-#{r}-#{c}"}
                data-status={"#{status}"}
                phx-click="toggle"
                phx-value-row={r}
                phx-value-col={c}
                class={get_classes_for_status(status) <> " h-28 p-1 flex justify-center items-center text-center text-xs sm:text-sm font-semibold sm:font-normal overflow-hidden cursor-pointer"}
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
      <% end %>
    </div>
    """
  end

  defp get_classes_for_status(true), do: "bg-pink-300"
  defp get_classes_for_status(_), do: "bg-indigo-200"
end

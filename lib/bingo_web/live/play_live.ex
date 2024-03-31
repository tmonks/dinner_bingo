defmodule BingoWeb.PlayLive do
  use BingoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    grid = Bingo.Grids.new_grid() |> IO.inspect()
    {:ok, assign(socket, grid: grid)}
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
              style="background-color: #eee; border: 1px solid black; width: 200px; text-align: center;"
            >
              <%= text %>
            </div>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end

defmodule Bingo.GridServer do
  use GenServer

  alias Bingo.Grids

  @doc """
  Starts the server.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  pings the server
  """
  def ping(server) do
    GenServer.call(server, :ping)
  end

  @doc """
  Retrieves the grid
  """
  def get_grid(server) do
    GenServer.call(server, :get_grid)
  end

  @doc """
  Toggles a cell in the grid
  """
  def toggle(server, row, col) do
    GenServer.call(server, {:toggle, row, col})
  end

  @impl true
  def init(:ok) do
    grid = Grids.new_grid()
    {:ok, grid}
  end

  @impl true
  def handle_call(:ping, _from, state) do
    {:reply, :pong, state}
  end

  @impl true
  def handle_call(:get_grid, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:toggle, row, col}, _from, grid) do
    grid = Grids.toggle_cell(grid, row, col)
    {:reply, grid, grid}
  end
end

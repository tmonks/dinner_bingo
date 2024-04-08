defmodule Bingo.GridServer do
  use GenServer

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

  @impl true
  def init(:ok) do
    IO.puts("Starting GridServer")
    {:ok, %{}}
  end

  @impl true
  def handle_call(:ping, _from, state) do
    IO.puts("Received ping")
    {:reply, :pong, state}
  end
end

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
end

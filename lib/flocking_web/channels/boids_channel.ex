defmodule FlockingWeb.BoidsChannel do
  use Phoenix.Channel
  alias Flocking.WorldStateUpdater

  def join("boids", _message, socket) do
    {:ok, socket}
  end

  def handle_in("update_settings", params, socket) do
    Enum.each(params, fn {name, value} ->
      WorldStateUpdater.update_setting(name, value)
    end)

    {:noreply, socket}
  end

  def handle_in("world_state", msg, socket) do
    broadcast!(socket, "world_state", msg)

    {:noreply, socket}
  end
end

defmodule Flocking.WorldStateUpdater do
  alias Flocking.Boid
  alias Flocking.Simulation
  alias Flocking.WorldState
  alias FlockingWeb.Endpoint

  use GenServer
  require Logger

  def start_link() do
    state = WorldState.new(100)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def update_setting(name, value) do
    GenServer.call(__MODULE__, {:update_setting, name, value})
  end

  def stop_loop() do
    GenServer.stop(__MODULE__)
  end

  def init(state) do
    Logger.warn("WorldStateUpdater started")
    broadcast!(state)
    trunc(1000 / state.settings.fps) |> schedule_timer()
    {:ok, state}
  end

  def handle_call({:update_setting, "boids", value}, _from, state) do
    boids_to_add = value - length(state.boids)

    boids =
      if boids_to_add <= 0 do
        Enum.take(state.boids, value)
      else
        Enum.map(0..boids_to_add, fn _ ->
          Boid.with_random_position(state.dimensions.width, state.dimensions.height)
        end)
        |> Enum.concat(state.boids)
      end

    new_state = %{state | boids: boids}

    {:reply, new_state, new_state}
  end

  def handle_call({:update_setting, name, value}, _from, state) do
    setting_name = String.to_atom(name)
    new_settings = Map.put(state.settings, setting_name, value)
    new_state = Map.put(state, :settings, new_settings)

    {:reply, new_state, new_state}
  end

  def handle_info(:tick, state) do
    broadcast!(state)

    boids =
      Enum.map(state.boids, fn boid ->
        Simulation.update_position(boid, state)
      end)

    state = %{state | boids: boids}
    trunc(1000 / state.settings.fps) |> schedule_timer()

    {:noreply, state}
  end

  defp schedule_timer(interval) do
    Process.send_after(self(), :tick, interval)
  end

  defp broadcast!(state) do
    Endpoint.broadcast!("boids", "world_state", state)
  end
end

defmodule Flocking.WorldState do
  alias Flocking.Boid

  @enforce_keys [:boids, :dimensions]
  defstruct [
    :dimensions,
    :boids,
    :settings,
    :obstacles,
    :predators,
    :lures
  ]

  def new(num_boids) do
    dimensions = %{width: 500, height: 500}

    boids =
      Enum.map(0..num_boids, fn _ ->
        Boid.with_random_position(dimensions.width, dimensions.height)
      end)

    %__MODULE__{
      boids: boids,
      settings: default_settings(),
      dimensions: dimensions
    }
  end

  def default_settings do
    %{
      fps: 30,
      cohesion_weight: 1,
      separation_weight: 1,
      alignment_weight: 1
    }
  end
end

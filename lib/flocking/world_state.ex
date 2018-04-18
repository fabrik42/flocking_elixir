defmodule Flocking.WorldState do
  alias Flocking.Boid

  @enforce_keys [:boids, :dimensions, :settings]
  defstruct [
    :boids,
    :dimensions,
    :settings
  ]

  def new(num_boids) do
    dimensions = %{width: 700, height: 700}

    boids =
      Enum.map(1..num_boids, fn _ ->
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

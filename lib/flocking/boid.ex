defmodule Flocking.Boid do
  alias Flocking.Vector

  @enforce_keys []
  defstruct [
    :acceleration,
    :velocity,
    :position,
    :size,
    :max_speed,
    :max_agility,
    :perception_radius,
    :personal_space_radius,
    :obstacle_avoidance_radius,
    :color
  ]

  def new() do
    %__MODULE__{}
  end

  def with_random_position(max_x, max_y) do
    build_default(
      Enum.random(0..max_x),
      Enum.random(0..max_y)
    )
  end

  def build_default(x, y) do
    %__MODULE__{
      acceleration: Vector.zero(),
      velocity: Vector.new(:rand.uniform() * 4, :rand.uniform() * 4),
      position: Vector.new(x, y),
      perception_radius: 40,
      personal_space_radius: 20,
      obstacle_avoidance_radius: 60,
      max_speed: 6,
      max_agility: 0.1,
      size: 20,
      color: %{
        r: :rand.uniform(255),
        g: :rand.uniform(255),
        b: :rand.uniform(255)
      }
    }
  end
end

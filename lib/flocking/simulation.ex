defmodule Flocking.Simulation do
  alias Flocking.Boid
  alias Flocking.Vector
  alias Flocking.WorldState

  def update_position(boid = %Boid{}, world_state = %WorldState{}) do
    acceleration = calculate_acceleration(boid, world_state)

    velocity =
      boid.velocity
      |> Vector.add(acceleration)
      |> Vector.limit(boid.max_speed)

    position = Vector.add(boid.position, velocity)

    %{boid | velocity: velocity, position: position, acceleration: acceleration}
    |> wrap_position(world_state)
  end

  def calculate_acceleration(boid = %Boid{}, world_state = %WorldState{}) do
    %{
      cohesion_weight: cohesion_weight,
      separation_weight: separation_weight,
      alignment_weight: alignment_weight
    } = world_state.settings

    others = boids_in_range(boid, world_state.boids)

    weighted_cohesion =
      calculate_cohesion(boid, others)
      |> Vector.multiply(cohesion_weight)

    weighted_separation =
      calculate_separation(boid, others)
      |> Vector.multiply(separation_weight)

    weighted_alignment =
      calculate_alignment(boid, others)
      |> Vector.multiply(alignment_weight)

    Vector.zero()
    |> Vector.add(weighted_cohesion)
    |> Vector.add(weighted_separation)
    |> Vector.add(weighted_alignment)
  end

  def calculate_cohesion(_boid, _others = []) do
    Vector.zero()
  end

  def calculate_cohesion(_boid, others) do
    # TODO: why the div 100????
    others
    |> Enum.reduce(Vector.zero(), fn b, v -> Vector.add(v, b.position) end)
    |> Vector.divide(length(others))
    |> Vector.divide(100)
  end

  def calculate_separation(boid, others) do
    close_boids =
      Enum.filter(others, fn b ->
        distance = Vector.distance(b.position, boid.position)
        distance != 0 && distance <= boid.personal_space_radius
      end)

    calculate_counter_vector(boid, close_boids)
  end

  def calculate_counter_vector(_boid, _others = []) do
    Vector.zero()
  end

  def calculate_counter_vector(boid, others) do
    others
    |> Enum.reduce(Vector.zero(), fn b, v ->
      counter_vector =
        b.position
        |> Vector.sub(boid.position)
        |> Vector.limit(boid.max_agility)

      Vector.sub(v, counter_vector)
    end)
    |> Vector.divide(length(others))
  end

  def calculate_alignment(_boid, _others = []) do
    Vector.zero()
  end

  def calculate_alignment(boid, others) do
    others
    |> Enum.reduce(Vector.zero(), fn b, v -> Vector.add(v, b.velocity) end)
    |> Vector.divide(length(others))
    |> Vector.limit(boid.max_agility)
  end

  def boids_in_range(boid, others) do
    Enum.filter(others, fn b ->
      b != boid && Vector.distance(b.position, boid.position) <= boid.perception_radius
    end)
  end

  def wrap_position(boid = %{position: position}, %{dimensions: dimensions}) do
    min_x_value = -boid.size
    min_y_value = -boid.size
    max_x_value = dimensions.width + boid.size
    max_y_value = dimensions.width + boid.size

    new_position =
      cond do
        position.x < min_x_value ->
          %{position | x: max_x_value}

        position.y < min_y_value ->
          %{position | y: max_y_value}

        position.x > max_x_value ->
          %{position | x: min_x_value}

        position.y > max_y_value ->
          %{position | y: min_y_value}

        true ->
          position
      end

    %{boid | position: new_position}
  end
end

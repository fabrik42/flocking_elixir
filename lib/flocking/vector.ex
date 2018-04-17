defmodule Flocking.Vector do
  @enforce_keys [:x, :y]
  defstruct [:x, :y]

  def new(x, y) do
    %__MODULE__{x: x, y: y}
  end

  def zero() do
    new(0, 0)
  end

  def add(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    new(x1 + x2, y1 + y2)
  end

  def sub(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    new(x1 - x2, y1 - y2)
  end

  def divide(%{x: x, y: y}, factor) do
    new(x / factor, y / factor)
  end

  def multiply(%{x: x, y: y}, factor) do
    new(x * factor, y * factor)
  end

  def distance(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    dx = x1 - x2
    dy = y1 - y2
    :math.sqrt(dx * dx + dy * dy)
  end

  def magnitude(%{x: x, y: y}) do
    :math.sqrt(x * x + y * y)
  end

  def heading(%{x: x, y: y}) do
    angle = :math.atan2(-y, x)
    -1 * angle
  end

  def towards_target(current, target, max_speed, max_agility, velocity) do
    desired = sub(target, current)
    distance = magnitude(desired)

    if distance == 0 do
      zero()
    else
      towards = desired |> normalize() |> multiply(max_speed)
      steer = sub(towards, velocity)
      limit(steer, max_agility)
    end
  end

  def normalize(vector) do
    m = magnitude(vector)

    if m > 0 do
      divide(vector, m)
    else
      vector
    end
  end

  def limit(vector, max) do
    if magnitude(vector) > max do
      normalize(vector) |> multiply(max)
    else
      vector
    end
  end
end

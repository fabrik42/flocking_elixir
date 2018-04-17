defmodule FlockingWeb.PageController do
  use FlockingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

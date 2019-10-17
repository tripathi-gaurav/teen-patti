defmodule TeenpattiWeb.PageController do
  use TeenpattiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

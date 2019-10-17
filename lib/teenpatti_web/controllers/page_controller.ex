defmodule TeenpattiWeb.PageController do
  use TeenpattiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def game(conn, %{"gameName" => gameName}) do
    render conn, "game.html", gameName: gameName
  end
end

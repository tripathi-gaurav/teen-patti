defmodule TeenpattiWeb.GameChannel do
use TeenpattiWeb, :channel
alias Teenpatti.Game
alias Teenpatti.BackupAgent

def join("game:" <> gameName, payload, socket) do
   if authorized?(payload) do
      game = BackupAgent.get(gameName) || Game.new()
      BackupAgent.put(gameName, game)
      socket = socket
          |> assign(:game, game)
          |> assign(:gameName, gameName)
      BackupAgent.put(gameName, game)
      {:ok, %{"join" => gameName, "game" => Game.client_view(game)}, socket}
   else
      {:error, %{reason: "unauthorized"}}
   end
end


def handle_in("join_game", %{"userName" => userName}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.addUserToMap(socket.assigns[:game], userName)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end  

defp authorized?( _payload ) do
        true
end

end


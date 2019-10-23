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

def handle_in("start_game", %{}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.start_game(socket.assigns[:game])
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("click_bet_seen", %{"turn" => turn, "betValue" => betValue}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.onClickBetSeen(socket.assigns[:game], turn, betValue)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("click_bet_blind", %{"turn" => turn, "betValue" => betValue}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.onClickBetBlind(socket.assigns[:game], turn, betValue)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("change_seen", %{"turn" => turn}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.changeSeen(socket.assigns[:game], turn)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("assign_cards", %{"turn" => turn}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.assignCards(socket.assigns[:game], turn)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("click_fold", %{"turn" => turn}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.click_fold(socket.assigns[:game], turn)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("change_show", %{"turn" => turn}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.change_show(socket.assigns[:game], turn)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("evaluate_show_seen", %{"turn" => turn}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.evaluate_show_seen(socket.assigns[:game], turn)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

def handle_in("evaluate_show_blind", %{"turn" => turn}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.evaluate_show_blind(socket.assigns[:game], turn)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game)}}, socket}
end

defp authorized?( _payload ) do
        true
end

end


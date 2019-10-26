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
      
      {:ok, %{"join" => gameName, "game" => Game.client_view(game, "")}, socket}
   else
      {:error, %{reason: "unauthorized"}}
   end
end


def handle_in("join_game", %{"userName" => userName}, socket) do
    gameName = socket.assigns[:gameName]
    #game = Game.addUserToMap(socket.assigns[:game], userName)
    game = BackupAgent.get( gameName )
    game = Game.addUserToMap(game, userName)
    socket = assign(socket, :game, game)
    #IO.inspect game
    #IO.inspect Game.client_view(game, game.userName)
    cnt = Enum.count game.players
    BackupAgent.put(gameName, game)
    IO.puts "players: #{cnt} backupagent name: #{gameName}"
    
    if cnt > 1 do
        IO.puts "broooooaddd: #{cnt}"
        x = broadcast socket, "refresh_view", %{"resp" => gameName}
        IO.inspect x
    end

    {:reply, {:ok, %{"game" => Game.client_view(game, game.player.session_id)}}, socket}
end  

def handle_in("refresh_view", %{"userName" => userName, "gameName" => gameName}, socket) do
    IO.puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&& #{gameName} #{userName}"
    
    game = socket.assigns[:game]
    game = BackupAgent.get( gameName )
    socket = assign(socket, :game, game)
    
    {:reply, {:ok, %{"game" => Game.client_view(game, userName)}}, socket}
end

def handle_in("start_game", %{"userName" => userName}, socket) do
    gameName = socket.assigns[:gameName]
    game = BackupAgent.get( gameName )
    IO.puts gameName
    game = Game.start_game(game)
    socket = assign(socket, :game, game)
    BackupAgent.put(gameName, game)
    
    
    cnt = Enum.count game.players
    if cnt > 1 do
        IO.puts "broooooaddd: #{cnt}"
        x = broadcast socket, "refresh_view", %{"resp" => gameName}
    end

    IO.puts "~~~~~~~~~~~~~~~~"
    game = Game.client_view(game, userName)
    
    {:reply, {:ok, %{"game" => game}}, socket}
end

def handle_in("reset_game", %{}, socket) do
    gameName = socket.assigns[:gameName]
    
    game = socket.assigns[:game]
    #game.isGameActive = false
    #game.turn = 0
    userName = game.userName

    game = Game.new()
    game = %{game | userName: userName }
    
    cnt = Enum.count game.players
    if cnt > 1 do
        IO.puts "broooooaddd: #{cnt}"
        broadcast!(socket, "reset_game", %{})
    end
    #game = Game.reset_game(socket.assigns[:game])
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
    IO.inspect game
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

def handle_in("see_cards", %{"userName" => session_id}, socket) do
    gameName = socket.assigns[:gameName]
    game = Game.see_cards(socket.assigns[:game], session_id)
    IO.puts "*******zzzzzzzzzz*********"
    IO.inspect game
    IO.puts "*************************"
    socket = assign(socket, :game, game)
    
    BackupAgent.put(gameName, game)
    {:reply, {:ok, %{"game" => Game.client_view(game, session_id)}}, socket}
end

# TODO: remove since see_cards should replace this
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


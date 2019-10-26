defmodule Teenpatti.Game do

alias Teenpatti.Player
alias Teenpatti.Ranking

def new do
   %{
       userName: "",
       listOfUsers: [],
       potMoney: 0,
       currentStakeAmount: 10,
       handForPlayer1: [],
       handForPlayer2: [],
       moneyPlayer1: 1000,
       moneyPlayer2: 1000,
       isShow: false,
       isFoldPlayer1: false,
       isFoldPlayer2: false,
       isGameActive: false,
       isBetPlayer1: false,
       isBetPlayer2: false,
       isSeenPlayer1: false,
       isSeenPlayer2: false,
       turn: 0,
       betValuePlayer1: 0,
       betValuePlayer2: 0,
       message1: "",
       message2: "",
       player: %Player{},
       players: %{},
	   listOfPlayers: [],
	   internal_all_players: %{}	#map of session id to player struct
    }
end

def addUserToMap(game, userName) do
     if(length(game.listOfUsers) != 5) do
          listUsers = game.listOfUsers ++ [userName]
          
		  #generate a unique session id for user
		  rand = :rand.uniform(65535)
		  current_time = :os.system_time(:millisecond)
		  key = "#{current_time}supersecretsalt#{rand}"
		  session_id = :crypto.hmac(:sha256, key, userName) |> Base.encode16 |> String.downcase()
		
		  players = game.players
		  new_player = if length( game.listOfUsers ) == 0 do
		  	%Player{user_name: userName, is_turn: true}
		  else
		  	%Player{user_name: userName}
		  end

		  #new_player = %Player{user_name: userName}
		  new_hand = assign_cards_to_blind(new_player.hand)
		  new_player = update_in( new_player.hand, &( &1 = new_hand ) )
		  new_player = update_in( new_player.session_id, &( &1 = session_id ) )
          #players = %{players | session_id: new_player }
		  players = Map.put players, session_id, new_player
		  IO.inspect players
		  
          game = %{game | listOfUsers: listUsers, players: players, 
		  player: new_player, userName: userName, internal_all_players: players}
		  IO.puts "==============================="
		  IO.inspect game
		  IO.puts "==============================="
		  game
     else
          game
     end
end

def update_money( map, session_id, amt ) do
	player = Map.fetch! map, session_id
	money = player.money_available - amt
	player = %Player{player | money_available: money}
	player
end

def update_internal_map_for_game_start( map, [ hd | tl] ) do
  player = update_money( map, hd, 10 )
  m = Map.put map, hd, player
  update_internal_map_for_game_start m, tl
end

def update_internal_map_for_game_start( map, _ ) do
  map
end

def start_game(game) do
	num_of_players = Enum.count game.players
	IO.puts num_of_players
	IO.puts "<<<<<<<<<<<"
	IO.inspect game
	IO.puts "<<<<<<<<<<<"
	if num_of_players >= 2 do
		pot_money = game.potMoney + num_of_players * game.currentStakeAmount
		keys = Map.keys( game.internal_all_players )
		map = update_internal_map_for_game_start( game.internal_all_players, keys )
		# players = Enum.map game.internal_all_players, fn {k,v} -> 
		# 									money_available = v.money_available - game.currentStakeAmount
		# 									{k, %Teenpatti.Player{v | money_available: money_available} } 
		# 								end
		
		IO.puts "pot_money: #{pot_money}"
		%{game | internal_all_players: map, potMoney: pot_money}
	else
		game
	end
end


def getListOfCards() do
    cardNumberList = [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    listOfMapOfCards = Enum.shuffle(create_list_of_cards_map(cardNumberList, []))
    listOfMapOfCards
end

def create_list_of_cards_map(cardNumberList, finalList) when length(cardNumberList) == 0 do
   finalList
end

def create_list_of_cards_map(cardNumberList, finalList) when length(cardNumberList) != 0 do
   card = hd(cardNumberList)
   spadeMap = %{value: card, type: "Spades"}
   heartMap = %{value: card, type: "Hearts"}
   clubMap = %{value: card, type: "Clubs"}
   diamondMap = %{value: card, type: "Diamonds"}
   create_list_of_cards_map(tl(cardNumberList), finalList ++ [spadeMap] ++ [heartMap] ++ [clubMap] ++ [diamondMap])
end

def get_index_of_player_using_key(keys, key) do
	get_index_of_player_using_key( keys, key, 0)
end

def get_index_of_player_using_key([hd|tl], key, index) do
	if ( hd == key ) do
		index
	else
		get_index_of_player_using_key( tl, key, index+1 )
	end
end

def get_index_of_player_using_key( _, _key, index) do
#this will probably NEVER execute
	index
end

def onClickBetSeen(game, turn, betValue) do

	players = game.internal_all_players
	currentStakeAmount = div(betValue,2)
	#update money_available with player
	player = update_money players, turn, betValue
	player = %Player{ player | is_turn: false }
	#udpate the current map of players
	players = Map.put players, turn, player
	#put the updated map of players in game.internal_all_players
	game = %{ game | internal_all_players: players, currentStakeAmount: currentStakeAmount }
	keys = Map.keys players
	index_of_player = get_index_of_player_using_key( keys, turn )
	#retreive next key
	
	session_id_of_next_player = if ( index_of_player == length(keys)-1 ) do
		Enum.at keys, 0
	else
		Enum.at keys, index_of_player+1
	end
	next_player = Map.fetch! players, session_id_of_next_player
	next_player = %Player{next_player | is_turn: true}
	players = Map.put players, session_id_of_next_player, next_player
	game = %{ game | internal_all_players: players}

	IO.puts "+++++++++++++++"
	#IO.puts "#{index_of_player} #{length(keys)}"
	#IO.inspect game
	IO.puts "+++++++++++++++"
	
	potMoney = game.potMoney + betValue
	%{game | potMoney: potMoney}

end

def onClickBetBlind(game, turn, betValue) do
    if(turn == 1) do
          potMoney= game.potMoney + betValue
          currentStakeAmount = betValue
          moneyPlayer1 = game.moneyPlayer1 - betValue
          isBetPlayer1 = false
          isBetPlayer2 = true
          turn = 2
       
          %{ game | potMoney: potMoney,
                    currentStakeAmount: currentStakeAmount,
                    moneyPlayer1: moneyPlayer1,
                    isBetPlayer1: isBetPlayer1,
                    isBetPlayer2: isBetPlayer2,
                    turn: turn
          }
    else
          potMoney= game.potMoney + betValue
          currentStakeAmount = betValue
          moneyPlayer2 = game.moneyPlayer2 - betValue
          isBetPlayer1 = true
          isBetPlayer2 = false
          turn = 1
       
          %{ game | potMoney: potMoney,
                    currentStakeAmount: currentStakeAmount,
                    moneyPlayer2: moneyPlayer2,
                    isBetPlayer1: isBetPlayer1,
                    isBetPlayer2: isBetPlayer2,
                    turn: turn
          }
    end
end

def changeSeen(game, turn) do
    if(turn == 1) do
          userName = ""
          isGameActive = true
          isBetPlayer1 = true
          isSeenPlayer1 = true
          turn = 1
               
          %{game |   userName: userName, 
               isGameActive: isGameActive,
               isBetPlayer1: isBetPlayer1, 
               isSeenPlayer1: isSeenPlayer1,
               turn: turn
          }
    else
          userName = ""
          isGameActive = true
          isBetPlayer2 = true
          isSeenPlayer2 = true
          turn = 2
          %{ game |  userName: userName, 
                         isGameActive: isGameActive, 
                         #isBetPlayer1: isBetPlayer1, 
                         isBetPlayer2: isBetPlayer2, 
                         turn: turn
          }
    end
end

def click_fold(game, turn) do
   if turn == 1 do
          userName = ""
          potMoney = 0
          turn = 0
          message2 = "Congratulations! You won this round!"
          moneyPlayer2 = game.moneyPlayer2 + game.potMoney
          %{
             game | userName: userName,
                    potMoney: potMoney,
                    turn: turn,
                    message2: message2,
                    moneyPlayer2: moneyPlayer2
          }
   else
          userName = ""
          potMoney = 0
          turn = 0
          message1 = "Congratulations! You won this round!"
          moneyPlayer1 = game.moneyPlayer1 + game.potMoney
          %{ game | userName: userName,
                    potMoney: potMoney,
                    turn: turn,
                    message1: message1,
                    moneyPlayer1: moneyPlayer1
          }   
   end
end

def change_show(game, turn) do
   %{ game | userName: "", isShow: true }
end




def assign_cards_to_blind(handForPlayer) do
     if(length(handForPlayer) != 0) do
             handForPlayer
     end
     listOfMapOfCards = getListOfCards()
     handForPlayer = Enum.slice(listOfMapOfCards, 3..5)
     handForPlayer
end

def evaluate_show(game, turn) do
	players = game.internal_all_players
	player = Map.fetch! players, turn #player1

	handForPlayer1 = player.hand

		money = player.money_available
		#charge the caller the bet amount
		money = if player.is_seen do
			money - 2 * game.currentStakeAmount
		else
			money - game.currentStakeAmount
		end
		
		player = Map.put player, :money_available, money

		keys = Map.keys players
		index_of_player = get_index_of_player_using_key( keys, turn )
		#retreive next key
		
		session_id_of_next_player = if ( index_of_player == length(keys)-1 ) do
			Enum.at keys, 0
		else
			Enum.at keys, index_of_player+1
		end
		next_player = Map.fetch! players, session_id_of_next_player #player2

		handForPlayer2 = next_player.hand

		message = Ranking.check_winner(handForPlayer1, handForPlayer2)
		# message content? 
		IO.puts message
		{winning_player, losing_player} = if String.contains? message, "Player1" do
														{ player, next_player }
													else
														{ next_player, player }
													end

	
	{winning_player, losing_player, money_available} = if player.is_seen do
		#evaluate for seen
		
		#either case..winning players money_avail increases 
		# money with winner
		money_available = game.potMoney + 2 * game.currentStakeAmount + winning_player.money_available
		{winning_player, losing_player, money_available}
		
	else
		#evaluate for blind
		money_available = game.potMoney + game.currentStakeAmount + winning_player.money_available
		{winning_player, losing_player, money_available}
	end

		winning_player = Map.put winning_player, :money_available, money_available
		winning_player = %Player{winning_player | is_seen: true}
		losing_player = %Player{losing_player | is_seen: true}
		temp_id = Map.fetch! winning_player, :session_id
		id_of_losing_player = Map.fetch! losing_player, :session_id
		players = players 	|> Map.put(temp_id, winning_player)
							|> Map.put(id_of_losing_player, losing_player)
		game =  Map.put game, :internal_all_players, players
		game = game |> Map.put :potMoney, 0
end


def see_cards(game, session_id) do
	
	player = Map.fetch! game.internal_all_players, session_id
	player = %{player | is_seen: true}
	#Map.update_in game.internal_all_players, session_id, &()
	players = update_in game.internal_all_players, [session_id], &(&1=player)
	
	
	# IO.puts "-----$$$$$------"
	# IO.inspect players
	# IO.puts "-----$$$$$------"
	# IO.inspect player
	# IO.puts "-----$$$$$------"
	%{game | player: player}
	#players = update_in game.players, [session_id], &(&1=player)
	%{game | internal_all_players: players}
end

def client_view(game) do
     userName = ""
    %{ game | userName: userName }
end

def client_view(game, session_id) do
	players = get_list_of_players(game, session_id)
	dummy = game.players
	dummy = unless is_list dummy do
		get_list_of_players(game, session_id)
	end
	game = %{game | players: dummy}
	IO.puts "!@#$%^&*()"
	IO.inspect players
	IO.puts "!@#$%^&*()"
	#player = get_in game.players, [ session_id ]
	#my_player = ( Enum.filter( players, fn x -> x.session_id == session_id end ) )
	player = if length( players ) == 0 do
		player = %Player{}
	else
		player = hd( Enum.filter( players, fn x -> x.session_id == session_id end ) )
	end
	
	game = %{game | players: players, player: player}
	# IO.inspect "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	# IO.inspect game
	# IO.inspect "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	game = Map.drop(game, [:internal_all_players] )
	game

end

def final_client_view(game, session_id) do
	players = get_list_of_players(game, session_id)
	
	map_of_players = game.internal_all_players #game.players
	players = Enum.map map_of_players, fn {k, v} -> 
	if k == session_id do
	%Teenpatti.Player{ 
			user_name: v.user_name, 
			money_available: v.money_available,
			is_show: v.is_show,
			is_seen: v.is_seen,
			is_turn: v.is_turn,
			session_id: v.session_id,
			hand: v.hand
			}
	else
	%Teenpatti.Player{ 
			user_name: v.user_name, 
			money_available: v.money_available,
			is_show: v.is_show,
			is_seen: v.is_seen,
			is_turn: v.is_turn,
			hand: v.hand
			}
	end
	end

	dummy = game.players
	dummy = unless is_list dummy do
		get_list_of_players(game, session_id)
	end
	game = %{game | players: dummy}
	
	player = if length( players ) == 0 do
		player = %Player{}
	else
		player = hd( Enum.filter( players, fn x -> x.session_id == session_id end ) )
	end
	
	game = %{game | players: players, player: player}
	# IO.inspect "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	# IO.inspect game
	# IO.inspect "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	game = Map.drop(game, [:internal_all_players] )
	game
end



def get_list_of_players(game, session_id) do
	map_of_players = game.internal_all_players #game.players
	players = Enum.map map_of_players, fn {k, v} -> 
	IO.puts k
	IO.puts session_id
	if( k == session_id ) do
		IO.puts "lock and load"
		IO.puts v.is_seen
		%Teenpatti.Player{ 
			user_name: v.user_name, 
			money_available: v.money_available,
			is_show: v.is_show,
			is_seen: v.is_seen,
			is_turn: v.is_turn,
			session_id: v.session_id,
			hand: v.hand
			}
	else
		%Teenpatti.Player{ 
			user_name: v.user_name, 
			money_available: v.money_available,
			is_seen: v.is_seen  #we will have to build a separate client_view method for the case of show
			} 
	end
	end
	# IO.puts "========asdas======="
	# IO.inspect players
	# IO.puts "==============="
	players
end

end

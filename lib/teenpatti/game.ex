defmodule Teenpatti.Game do

alias Teenpatti.Player

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
		  new_player = %Player{user_name: userName}
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

def start_game(game) do
	num_of_players = Enum.count game.players
	IO.puts num_of_players
	if num_of_players >= 2 do
		pot_money = game.potMoney + num_of_players * game.currentStakeAmount
		players = Enum.map game.internal_all_players, fn {k,v} -> 
											money_available = v.money_available - game.currentStakeAmount
											{k, %Teenpatti.Player{v | money_available: money_available} } 
										end
		IO.puts "pot_money: #{pot_money}"
		
		%{game | internal_all_players: players, potMoney: pot_money}
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

def onClickBetSeen(game, turn, betValue) do
   if(turn == 1) do
   potMoney = game.potMoney + betValue
   currentStakeAmount = div(betValue,2)
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
          potMoney = game.potMoney + betValue
          currentStakeAmount = div(betValue,2)
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

def check_winner(handForPlayer1, handForPlayer2) do
    sahandForPlayer1 = Enum.sort_by handForPlayer1, &Map.fetch!(&1, :value)
	sahandForPlayer2 = Enum.sort_by handForPlayer2, &Map.fetch!(&1, :value)
	shandForPlayer1 = Enum.reverse(sahandForPlayer1)
	shandForPlayer2 = Enum.reverse(sahandForPlayer2)
    card_1_player_1 = Map.fetch!(hd(shandForPlayer1), :value)
    type_1_player_1 = Map.fetch!(hd(shandForPlayer1), :type)
    card_2_player_1 = Map.fetch!(hd(tl(shandForPlayer1)), :value)
    type_2_player_1 = Map.fetch!(hd(tl(shandForPlayer1)), :type)
    card_3_player_1 = Map.fetch!(hd(tl(tl(shandForPlayer1))), :value)
    type_3_player_1 = Map.fetch!(hd(tl(tl(shandForPlayer1))), :type)
    card_1_player_2 = Map.fetch!(hd(shandForPlayer2), :value)
    type_1_player_2 = Map.fetch!(hd(shandForPlayer2), :type)
    card_2_player_2 = Map.fetch!(hd(tl(shandForPlayer2)), :value)
    type_2_player_2 = Map.fetch!(hd(tl(shandForPlayer2)), :type)
    card_3_player_2 = Map.fetch!(hd(tl(tl(shandForPlayer2))), :value)
    type_3_player_2 = Map.fetch!(hd(tl(tl(shandForPlayer2))), :type)
    cardConstantsMap = %{
                          14 => 14,
                          13 => 13,
                          12 => 12,
                          11 => 11,
                          10 => 10,
                          9 => 9,
                          8 => 8,
                          7 => 7,
                          6 => 6,
                          5 => 5,
                          4 => 4,
                          3 => 3,
                          2 => 2
                        }
	
	 #both players cards equal
     if(card_1_player_1 == card_1_player_2 && card_2_player_1 == card_2_player_2 && card_3_player_1 == card_3_player_2) do
              "This round is a draw."
     end
	 
	 #Trio
     if(card_1_player_1 == card_2_player_1 && card_1_player_1 == card_3_player_1) do
              if(card_1_player_2 == card_2_player_2 && card_1_player_2 == card_3_player_2) do
                    if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
                            "Player1 won this round."
                    else
                            "Player2 won this round."
                    end
              else
                  "Player1 won this round."
              end
     end
	 if(card_1_player_2 == card_2_player_2 && card_1_player_2 == card_3_player_2) do
              if(card_1_player_1 == card_2_player_1 && card_1_player_1 == card_3_player_1) do
                    if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
                            "Player2 won this round."
                    else
                            "Player1 won this round."
                    end
              else
                  "Player1 won this round."
              end
     end
	 
	 #Straight Run
     if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_1_player_1) - 1 
	    && Map.fetch!(cardConstantsMap, card_3_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1) - 1 
	    && type_1_player_1 == type_2_player_1 && type_1_player_1 == type_3_player_1) do
	              if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_1_player_2) - 1 
	                && Map.fetch!(cardConstantsMap, card_3_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2) - 1 
	                && type_1_player_2 == type_2_player_2 && type_1_player_2 == type_3_player_2) do
				           if((Map.fetch!(cardConstantsMap, card_1_player_1) + Map.fetch!(cardConstantsMap, card_2_player_1) + Map.fetch!(cardConstantsMap, card_3_player_1)) 
						      > (Map.fetch!(cardConstantsMap, card_1_player_2) + Map.fetch!(cardConstantsMap, card_2_player_2) + Map.fetch!(cardConstantsMap, card_3_player_2))) do
						             "Player1 won this round."
						   else
						             "Player2 won this round."
						   end
				  else
				      "Player1 won this round."
				  end
	 end
     if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_1_player_2) - 1 
	    && Map.fetch!(cardConstantsMap, card_3_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2) - 1 
	    && type_1_player_2 == type_2_player_2 && type_1_player_2 == type_3_player_2) do
	              if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_1_player_1) - 1 
	                && Map.fetch!(cardConstantsMap, card_3_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1) - 1 
	                && type_1_player_1 == type_2_player_1 && type_1_player_1 == type_3_player_1) do
				           if((Map.fetch!(cardConstantsMap, card_1_player_2) + Map.fetch!(cardConstantsMap, card_2_player_2) + Map.fetch!(cardConstantsMap, card_3_player_2)) 
						      > (Map.fetch!(cardConstantsMap, card_1_player_1) + Map.fetch!(cardConstantsMap, card_2_player_1) + Map.fetch!(cardConstantsMap, card_3_player_1))) do
						             "Player2 won this round."
						   else
						             "Player1 won this round."
						   end
				  else
				      "Player2 won this round."
				  end
	 end
	 
	 #NormalRun
	 if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_1_player_1) - 1 
	    && Map.fetch!(cardConstantsMap, card_3_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1) - 1) do
	              if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_1_player_2) - 1 
	                && Map.fetch!(cardConstantsMap, card_3_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2) - 1) do
				           if((Map.fetch!(cardConstantsMap, card_1_player_1) + Map.fetch!(cardConstantsMap, card_2_player_1) + Map.fetch!(cardConstantsMap, card_3_player_1)) 
						      > (Map.fetch!(cardConstantsMap, card_1_player_2) + Map.fetch!(cardConstantsMap, card_2_player_2) + Map.fetch!(cardConstantsMap, card_3_player_2))) do
						             "Player1 won this round."
						   else
						             "Player2 won this round."
						   end
				  else
				      "Player1 won this round."
				  end
	 end
     if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_1_player_2) - 1 
	    && Map.fetch!(cardConstantsMap, card_3_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2) - 1) do
	              if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_1_player_1) - 1 
	                && Map.fetch!(cardConstantsMap, card_3_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1) - 1) do
				           if((Map.fetch!(cardConstantsMap, card_1_player_2) + Map.fetch!(cardConstantsMap, card_2_player_2) + Map.fetch!(cardConstantsMap, card_3_player_2)) 
						      > (Map.fetch!(cardConstantsMap, card_1_player_1) + Map.fetch!(cardConstantsMap, card_2_player_1) + Map.fetch!(cardConstantsMap, card_3_player_1))) do
						             "Player2 won this round."
						   else
						             "Player1 won this round."
						   end
				  else
				      "Player2 won this round."
				  end
	 end
	 
	 #Color
	 if(type_1_player_1 == type_2_player_1 && type_1_player_1 == type_3_player_1) do
	          if(type_1_player_2 == type_2_player_2 && type_1_player_2 == type_3_player_2) do
			            if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
						            if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
                                                if(Map.fetch!(cardConstantsMap, card_3_player_1) > Map.fetch!(cardConstantsMap, card_3_player_2)) do
                                                    "Player1 won this round."
												else
												    "Player2 won this round."
												end
                                    else
                                        if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
                                             "Player1 won this round."
										else
										     "Player2 won this round"
                                        end										
									end
						else
						      if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
							       "Player1 won this round."
                              else
							       "Player2 won this round."
                              end							  						
						end
			  else
			       "Player1 won this round."
			  end
	    "Player1 won this round."
	 end
	 if(type_1_player_2 == type_2_player_2 && type_1_player_2 == type_3_player_2) do
	          if(type_1_player_1 == type_2_player_1 && type_1_player_1 == type_3_player_1) do
			            if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_1_player_1)) do
						            if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
                                                if(Map.fetch!(cardConstantsMap, card_3_player_2) > Map.fetch!(cardConstantsMap, card_3_player_1)) do
                                                    "Player2 won this round."
												else
												    "Player1 won this round."
												end
                                    else
                                        if(Map.fetch!(cardConstantsMap, card_2_player_2) > Map.fetch!(cardConstantsMap, card_2_player_1)) do
                                             "Player2 won this round."
										else
										     "Player1 won this round"
                                        end										
									end
						else
						      if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
							       "Player2 won this round."
                              else
							       "Player1 won this round."
                              end							  						
						end
			  else
			       "Player2 won this round."
			  end
	    "Player2 won this round."
	 end
	 
	 #Pair
	 if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
	            if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_3_player_1) > Map.fetch!(cardConstantsMap, card_3_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_3_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_3_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				"Player1 won this round."
	 end
	 
	 if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
	            if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_3_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				"Player1 won this round."
	 end
	 
	 if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
	            if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_3_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
								         if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
										      "Player1 won this round."
										 else
										      "Player2 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
									     "Player1 won this round."
									else
									     " Player2 won this round."
									end
								end
				end
				"Player1 won this round."
	 end
	 
	
	 
	 if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
	            if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_1_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_3_player_2) > Map.fetch!(cardConstantsMap, card_3_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_3_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_2_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_1_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_3_player_2) > Map.fetch!(cardConstantsMap, card_2_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				"Player2 won this round."
	 end
	 
	 if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
	            if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_1_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_3_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_2_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_2_player_2) > Map.fetch!(cardConstantsMap, card_2_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_2_player_2) == Map.fetch!(cardConstantsMap, card_1_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_2_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_2_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				"Player2 won this round."
	 end
	 
	 if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_3_player_2)) do
	            if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_1_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_2_player_2) > Map.fetch!(cardConstantsMap, card_3_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_2_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_2_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_2_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_3_player_1)) do
				                if(Map.fetch!(cardConstantsMap, card_1_player_2) == Map.fetch!(cardConstantsMap, card_1_player_1)) do
								         if(Map.fetch!(cardConstantsMap, card_2_player_2) > Map.fetch!(cardConstantsMap, card_2_player_1)) do
										      "Player2 won this round."
										 else
										      "Player1 won this round."
										 end
								else
								    if(Map.fetch!(cardConstantsMap, card_1_player_2) > Map.fetch!(cardConstantsMap, card_1_player_1)) do
									     "Player2 won this round."
									else
									     " Player1 won this round."
									end
								end
				end
				"Player2 won this round."
	 end
	 
	 #High Card
	 if(Map.fetch!(cardConstantsMap, card_1_player_1) == Map.fetch!(cardConstantsMap, card_1_player_2)) do
             	   if(Map.fetch!(cardConstantsMap, card_2_player_1) == Map.fetch!(cardConstantsMap, card_2_player_2)) do
				                     if(Map.fetch!(cardConstantsMap, card_3_player_1) > Map.fetch!(cardConstantsMap, card_3_player_2)) do
									          "Player1 won this round."
									 else
									          "Player2 won this round."
									 end
				   else
				                    if(Map.fetch!(cardConstantsMap, card_2_player_1) > Map.fetch!(cardConstantsMap, card_2_player_2)) do
									          "Player1 won this round."
									 else
									          "Player2 won this round."
									 end 
				   end
	 else
	        if(Map.fetch!(cardConstantsMap, card_1_player_1) > Map.fetch!(cardConstantsMap, card_1_player_2)) do
									          "Player1 won this round."
									 else
									          "Player2 won this round."
									 end  
	 end     
end


def assign_cards_to_blind(handForPlayer) do
     if(length(handForPlayer) != 0) do
             handForPlayer
     end
     listOfMapOfCards = getListOfCards()
     handForPlayer = Enum.slice(listOfMapOfCards, 3..5)
     handForPlayer
end


def evaluate_show_seen(game, turn) do
   handForPlayer2 = assign_cards_to_blind(game.handForPlayer2)
   message = check_winner(game.handForPlayer1, handForPlayer2)
     userName = ""
     potMoney = game.potMoney + 2 * game.currentStakeAmount
     
     isShow = false
     isFoldPlayer1 = false
     isFoldPlayer2 = false
     isBetPlayer2 = false
     isBetPlayer1 = false
     
     turn = 0
     betValuePlayer1 = 0
     betValuePlayer2 = 0
   message2 = message
   if(turn == 1) do
     moneyPlayer1 = game.moneyPlayer1 - 2 * game.currentStakeAmount
     isSeenPlayer2 = true
     %{   game |    userName: userName,
                    potMoney: potMoney,
                    moneyPlayer1: moneyPlayer1,
                         isShow: isShow,
                         isFoldPlayer1: isFoldPlayer1,
                         isFoldPlayer2: isFoldPlayer2,
                         isBetPlayer1: isBetPlayer1,
                         isBetPlayer2: isBetPlayer2,
                    isSeenPlayer2: isSeenPlayer2,
                         turn: turn,
                         betValuePlayer1: betValuePlayer1,
                         betValuePlayer2: betValuePlayer2,
                         message2: message
     }
   else
     moneyPlayer2 = game.moneyPlayer2 - 2 * game.currentStakeAmount
     isSeenPlayer1 = true
    %{ game |  userName: userName,
               potMoney: potMoney,
               moneyPlayer2: moneyPlayer2,
                    isShow: isShow,
                    isFoldPlayer1: isFoldPlayer1,
                    isFoldPlayer2: isFoldPlayer2,
                    isBetPlayer1: isBetPlayer1,
                    isBetPlayer2: isBetPlayer2,
               isSeenPlayer1: isSeenPlayer1,
                    turn: turn,
                    betValuePlayer1: betValuePlayer1,
                    betValuePlayer2: betValuePlayer2,
                    message2: message
    }
   end
    
end

def evaluate_show_blind(game, turn) do
     handForPlayer2 = assign_cards_to_blind(game.handForPlayer2)
     handForPlayer1 = assign_cards_to_blind(game.handForPlayer1)
     message = check_winner(handForPlayer1, handForPlayer2)

     if(turn == 1) do
     %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney + game.currentStakeAmount,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: handForPlayer1,
      handForPlayer2: handForPlayer2,
      moneyPlayer1: game.moneyPlayer1 - game.currentStakeAmount,
      moneyPlayer2: game.moneyPlayer2,
      isShow: false,
      isFoldPlayer1: false,
      isFoldPlayer2: false,
      isGameActive: game.isGameActive,
      isBetPlayer1: false,
      isBetPlayer2: false,
      isSeenPlayer1: true,
      isSeenPlayer2: true,
      turn: 0,
      betValuePlayer1: 0,
      betValuePlayer2: 0,
      message1: game.message1,
      message2: message
     }
     else
     %{
       userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney + game.currentStakeAmount,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: handForPlayer1,
      handForPlayer2: handForPlayer2,
      moneyPlayer1: game.moneyPlayer1,
      moneyPlayer2: game.moneyPlayer2 - game.currentStakeAmount,
      isShow: false,
      isFoldPlayer1: false,
      isFoldPlayer2: false,
      isGameActive: game.isGameActive,
      isBetPlayer1: false,
      isBetPlayer2: false,
      isSeenPlayer1: true,
      isSeenPlayer2: true,
      turn: 0,
      betValuePlayer1: 0,
      betValuePlayer2: 0,
      message1: game.message1,
      message2: message
     }
     end
end

def assignCards(game, turn) do 
     listOfMapOfCards = getListOfCards()
     cond do
          turn == 1 and game.isSeenPlayer1 == false ->
               handForPlayer1 = Enum.slice(listOfMapOfCards, 0..2)
               %{ game | handForPlayer1: handForPlayer1, isSeenPlayer1: true }
          turn == 2 and game.isSeenPlayer2 == false ->
               handForPlayer2 = Enum.slice(listOfMapOfCards, 3..5)
               %{ game | handForPlayer2: handForPlayer2, isSeenPlayer2: true }
          true -> game
    end
end

def see_cards(game, session_id) do
	#player = get_in game.players, [session_id]
	#players = get_list_of_players(game, session_id)
	#player = hd( Enum.filter( players, fn x -> x.session_id == session_id end ) )
	#player = game.internal_all_players[session_id]
	player = Map.fetch! game.internal_all_players, session_id
	player = %{player | is_seen: true}
	#Map.update_in game.internal_all_players, session_id, &()
	players = update_in game.internal_all_players, [session_id], &(&1=player)
	# players = Enum.map game.internal_all_players, fn {k,v} -> 
	# 					if k == session_id do
	# 						player
	# 					else
	# 						x
	# 					end
	# 				end
	
	IO.puts "-----$$$$$------"
	IO.inspect players
	IO.puts "-----$$$$$------"
	IO.inspect player
	IO.puts "-----$$$$$------"
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
	#player = %Player{player | is_seen}
	#IO.puts "==========FINAL============="
	#IO.inspect players
	#IO.puts "============================="
	#update_in players, [session_id], &(&1=player)
	game = %{game | players: players, player: player}
	# IO.inspect "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	# IO.inspect game
	# IO.inspect "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	game = Map.drop(game, [:internal_all_players] )
	game

end

def final_client_view(game, session_id) do

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
			session_id: v.session_id,
			hand: v.hand
			}
	else
		%Teenpatti.Player{ 
			user_name: v.user_name, 
			money_available: v.money_available  
			} 
	end
	end
	# IO.puts "========asdas======="
	# IO.inspect players
	# IO.puts "==============="
	players
end

end

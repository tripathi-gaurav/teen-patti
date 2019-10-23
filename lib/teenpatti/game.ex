defmodule Teenpatti.Game do

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
       message2: ""
    }
end

def addUserToMap(game, userName) do
     if(length(game.listOfUsers) != 5) do
          listUsers = game.listOfUsers ++ [userName];
          %{
             userName: game.userName,
             listOfUsers: listUsers,
             potMoney: game.potMoney,
             currentStakeAmount: game.currentStakeAmount,
             handForPlayer1: game.handForPlayer1,
             handForPlayer2: game.handForPlayer2,
             moneyPlayer1: game.moneyPlayer1,
             moneyPlayer2: game.moneyPlayer2,
             isShow: game.isShow,
             isFoldPlayer1: game.isFoldPlayer1,
             isFoldPlayer2: game.isFoldPlayer2,
             isGameActive: game.isGameActive,
             isBetPlayer1: game.isBetPlayer1,
             isBetPlayer2: game.isBetPlayer2,
             isSeenPlayer1: game.isSeenPlayer1,
             isSeenPlayer2: game.isSeenPlayer2,
             turn: game.turn,
             betValuePlayer1: game.betValuePlayer1,
             betValuePlayer2: game.betValuePlayer2,
             message1: game.message1,
             message2: game.message2
           }
     else
          game
     end
end

def start_game(game) do

  if (length(game.listOfUsers) >= 2 && !game.isGameActive && game.turn == 0) do
     %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney + (length(game.listOfUsers) * game.currentStakeAmount),
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: game.handForPlayer2,
      moneyPlayer1: game.moneyPlayer1 - game.currentStakeAmount,
      moneyPlayer2: game.moneyPlayer2 - game.currentStakeAmount,
      isShow: game.isShow,
      isFoldPlayer1: game.isFoldPlayer1,
      isFoldPlayer2: game.isFoldPlayer2,
      isGameActive: true,
      isBetPlayer1: true,
      isBetPlayer2: game.isBetPlayer2,
      isSeenPlayer1: game.isSeenPlayer1,
      isSeenPlayer2: game.isSeenPlayer2,
      turn: 1,
      betValuePlayer1: game.betValuePlayer1,
      betValuePlayer2: game.betValuePlayer2,
      message1: game.message1,
      message2: game.message2
    }
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
       %{
             userName: game.userName,
             listOfUsers: game.listOfUsers,
             potMoney: game.potMoney + betValue,
             currentStakeAmount: div(betValue,2),
             handForPlayer1: game.handForPlayer1,
             handForPlayer2: game.handForPlayer2,
             moneyPlayer1: game.moneyPlayer1 - betValue,
             moneyPlayer2: game.moneyPlayer2,
             isShow: game.isShow,
             isFoldPlayer1: game.isFoldPlayer1,
             isFoldPlayer2: game.isFoldPlayer2,
             isGameActive: game.isGameActive,
             isBetPlayer1: false,
             isBetPlayer2: true,
             isSeenPlayer1: game.isSeenPlayer1,
             isSeenPlayer2: game.isSeenPlayer2,
             turn: 2,
             betValuePlayer1: game.betValuePlayer1,
             betValuePlayer2: game.betValuePlayer2,
             message1: game.message1,
             message2: game.message2
        }        
   else
      %{
             userName: game.userName,
             listOfUsers: game.listOfUsers,
             potMoney: game.potMoney + betValue,
             currentStakeAmount: div(betValue,2),
             handForPlayer1: game.handForPlayer1,
             handForPlayer2: game.handForPlayer2,
             moneyPlayer1: game.moneyPlayer1,
             moneyPlayer2: game.moneyPlayer2 - betValue,
             isShow: game.isShow,
             isFoldPlayer1: game.isFoldPlayer1,
             isFoldPlayer2: game.isFoldPlayer2,
             isGameActive: game.isGameActive,
             isBetPlayer1: true,
             isBetPlayer2: false,
             isSeenPlayer1: game.isSeenPlayer1,
             isSeenPlayer2: game.isSeenPlayer2,
             turn: 1,
             betValuePlayer1: game.betValuePlayer1,
             betValuePlayer2: game.betValuePlayer2,
             message1: game.message1,
             message2: game.message2
      }
   end
end

def onClickBetBlind(game, turn, betValue) do
    if(turn == 1) do
       %{
             userName: game.userName,
             listOfUsers: game.listOfUsers,
             potMoney: game.potMoney + betValue,
             currentStakeAmount: betValue,
             handForPlayer1: game.handForPlayer1,
             handForPlayer2: game.handForPlayer2,
             moneyPlayer1: game.moneyPlayer1 - betValue,
             moneyPlayer2: game.moneyPlayer2,
             isShow: game.isShow,
             isFoldPlayer1: game.isFoldPlayer1,
             isFoldPlayer2: game.isFoldPlayer2,
             isGameActive: game.isGameActive,
             isBetPlayer1: false,
             isBetPlayer2: true,
             isSeenPlayer1: game.isSeenPlayer1,
             isSeenPlayer2: game.isSeenPlayer2,
             turn: 2,
             betValuePlayer1: game.betValuePlayer1,
             betValuePlayer2: game.betValuePlayer2,
             message1: game.message1,
             message2: game.message2
       }
    else
       %{
             userName: game.userName,
             listOfUsers: game.listOfUsers,
             potMoney: game.potMoney + betValue,
             currentStakeAmount: betValue,
             handForPlayer1: game.handForPlayer1,
             handForPlayer2: game.handForPlayer2,
             moneyPlayer1: game.moneyPlayer1,
             moneyPlayer2: game.moneyPlayer2 - betValue,
             isShow: game.isShow,
             isFoldPlayer1: game.isFoldPlayer1,
             isFoldPlayer2: game.isFoldPlayer2,
             isGameActive: game.isGameActive,
             isBetPlayer1: true,
             isBetPlayer2: false,
             isSeenPlayer1: game.isSeenPlayer1,
             isSeenPlayer2: game.isSeenPlayer2,
             turn: 1,
             betValuePlayer1: game.betValuePlayer1,
             betValuePlayer2: game.betValuePlayer2,
             message1: game.message1,
             message2: game.message2
       }
    end
end

def changeSeen(game, turn) do
    if(turn == 1) do
     %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: game.handForPlayer2,
      moneyPlayer1: game.moneyPlayer1,
      moneyPlayer2: game.moneyPlayer2,
      isShow: game.isShow,
      isFoldPlayer1: game.isFoldPlayer1,
      isFoldPlayer2: game.isFoldPlayer2,
      isGameActive: true,
      isBetPlayer1: true,
      isBetPlayer2: game.isBetPlayer2,
      isSeenPlayer1: true,
      isSeenPlayer2: game.isSeenPlayer2,
      turn: 1,
      betValuePlayer1: game.betValuePlayer1,
      betValuePlayer2: game.betValuePlayer2,
      message1: game.message1,
      message2: game.message2
    }
    else
    %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: game.handForPlayer2,
      moneyPlayer1: game.moneyPlayer1,
      moneyPlayer2: game.moneyPlayer2,
      isShow: game.isShow,
      isFoldPlayer1: game.isFoldPlayer1,
      isFoldPlayer2: game.isFoldPlayer2,
      isGameActive: true,
      isBetPlayer1: game.isBetPlayer1,
      isBetPlayer2: true,
      isSeenPlayer1: game.isSeenPlayer1,
      isSeenPlayer2: true,
      turn: 2,
      betValuePlayer1: game.betValuePlayer1,
      betValuePlayer2: game.betValuePlayer2,
      message1: game.message1,
      message2: game.message2
    }
    end
end

def click_fold(game, turn) do
   if turn == 1 do
    %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: 0,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: game.handForPlayer2,
      moneyPlayer1: game.moneyPlayer1,
      moneyPlayer2: game.moneyPlayer2 + game.potMoney,
      isShow: game.isShow,
      isFoldPlayer1: game.isFoldPlayer1,
      isFoldPlayer2: game.isFoldPlayer2,
      isGameActive: game.isGameActive,
      isBetPlayer1: game.isBetPlayer1,
      isBetPlayer2: game.isBetPlayer2,
      isSeenPlayer1: game.isSeenPlayer1,
      isSeenPlayer2: game.isSeenPlayer2,
      turn: 0,
      betValuePlayer1: game.betValuePlayer1,
      betValuePlayer2: game.betValuePlayer2,
      message1: game.message1,
      message2: "Congratulations! You won this round!"
    }
   else
    %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: 0,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: game.handForPlayer2,
      moneyPlayer1: game.moneyPlayer1 + game.potMoney,
      moneyPlayer2: game.moneyPlayer2,
      isShow: game.isShow,
      isFoldPlayer1: game.isFoldPlayer1,
      isFoldPlayer2: game.isFoldPlayer2,
      isGameActive: game.isGameActive,
      isBetPlayer1: game.isBetPlayer1,
      isBetPlayer2: game.isBetPlayer2,
      isSeenPlayer1: game.isSeenPlayer1,
      isSeenPlayer2: game.isSeenPlayer2,
      turn: 0,
      betValuePlayer1: game.betValuePlayer1,
      betValuePlayer2: game.betValuePlayer2,
      message1: "Congratulations! You won the round!",
      message2: game.message2
    }   
   end
end

def change_show(game, turn) do
   %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: game.handForPlayer2,
      moneyPlayer1: game.moneyPlayer1,
      moneyPlayer2: game.moneyPlayer2,
      isShow: true,
      isFoldPlayer1: game.isFoldPlayer1,
      isFoldPlayer2: game.isFoldPlayer2,
      isGameActive: game.isGameActive,
      isBetPlayer1: game.isBetPlayer1,
      isBetPlayer2: game.isBetPlayer2,
      isSeenPlayer1: game.isSeenPlayer1,
      isSeenPlayer2: game.isSeenPlayer2,
      turn: game.turn,
      betValuePlayer1: game.betValuePlayer1,
      betValuePlayer2: game.betValuePlayer2,
      message1: game.message1,
      message2: game.message2
    }
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
   if(turn == 1) do
     %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney + 2 * game.currentStakeAmount,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: handForPlayer2,
      moneyPlayer1: game.moneyPlayer1 - 2 * game.currentStakeAmount,
      moneyPlayer2: game.moneyPlayer2,
      isShow: false,
      isFoldPlayer1: false,
      isFoldPlayer2: false,
      isGameActive: game.isGameActive,
      isBetPlayer1: false,
      isBetPlayer2: false,
      isSeenPlayer1: game.isSeenPlayer1,
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
      potMoney: game.potMoney + 2 * game.currentStakeAmount,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: handForPlayer2,
      moneyPlayer1: game.moneyPlayer1,
      moneyPlayer2: game.moneyPlayer2 - 2 * game.currentStakeAmount,
      isShow: false,
      isFoldPlayer1: false,
      isFoldPlayer2: false,
      isGameActive: game.isGameActive,
      isBetPlayer1: false,
      isBetPlayer2: false,
      isSeenPlayer1: true,
      isSeenPlayer2: game.isSeenPlayer2,
      turn: 0,
      betValuePlayer1: 0,
      betValuePlayer2: 0,
      message1: game.message1,
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
     if turn == 1 do
          handForPlayer1 = Enum.slice(listOfMapOfCards, 0..2)
           %{
              userName: "",
              listOfUsers: game.listOfUsers,
              potMoney: game.potMoney,
              currentStakeAmount: game.currentStakeAmount,
              handForPlayer1: handForPlayer1,
              handForPlayer2: game.handForPlayer2,
              moneyPlayer1: game.moneyPlayer1,
              moneyPlayer2: game.moneyPlayer2,
              isShow: game.isShow,
              isFoldPlayer1: game.isFoldPlayer1,
              isFoldPlayer2: game.isFoldPlayer2,
              isGameActive: game.isGameActive,
              isBetPlayer1: game.isBetPlayer1,
              isBetPlayer2: game.isBetPlayer2,
              isSeenPlayer1: game.isSeenPlayer1,
              isSeenPlayer2: game.isSeenPlayer2,
              turn: game.turn,
              betValuePlayer1: game.betValuePlayer1,
              betValuePlayer2: game.betValuePlayer2,
              message1: game.message1,
              message2: game.message2
     }
     else
          handForPlayer2 = Enum.slice(listOfMapOfCards, 3..5)
           %{
              userName: "",
              listOfUsers: game.listOfUsers,
              potMoney: game.potMoney,
              currentStakeAmount: game.currentStakeAmount,
              handForPlayer1: game.handForPlayer1,
              handForPlayer2: handForPlayer2,
              moneyPlayer1: game.moneyPlayer1,
              moneyPlayer2: game.moneyPlayer2,
              isShow: game.isShow,
              isFoldPlayer1: game.isFoldPlayer1,
              isFoldPlayer2: game.isFoldPlayer2,
              isGameActive: game.isGameActive,
              isBetPlayer1: game.isBetPlayer1,
              isBetPlayer2: game.isBetPlayer2,
              isSeenPlayer1: game.isSeenPlayer1,
              isSeenPlayer2: game.isSeenPlayer2,
              turn: game.turn,
              betValuePlayer1: game.betValuePlayer1,
              betValuePlayer2: game.betValuePlayer2,
              message1: game.message1,
              message2: game.message2
            }
    end
end

def client_view(game) do
    %{
      userName: "",
      listOfUsers: game.listOfUsers,
      potMoney: game.potMoney,
      currentStakeAmount: game.currentStakeAmount,
      handForPlayer1: game.handForPlayer1,
      handForPlayer2: game.handForPlayer2,
      moneyPlayer1: game.moneyPlayer1,
      moneyPlayer2: game.moneyPlayer2,
      isShow: game.isShow,
      isFoldPlayer1: game.isFoldPlayer1,
      isFoldPlayer2: game.isFoldPlayer2,
      isGameActive: game.isGameActive,
      isBetPlayer1: game.isBetPlayer1,
      isBetPlayer2: game.isBetPlayer2,
      isSeenPlayer1: game.isSeenPlayer1,
      isSeenPlayer2: game.isSeenPlayer2,
      turn: game.turn,
      betValuePlayer1: game.betValuePlayer1,
      betValuePlayer2: game.betValuePlayer2,
      message1: game.message1,
      message2: game.message2
    }
end

end

defmodule Teenpatti.Ranking do

    

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

end
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
    cardNumberList = ["A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2"]
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

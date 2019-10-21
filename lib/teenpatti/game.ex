defmodule Teenpatti.Game do

def new do
   %{
       userName: "",
       listOfUsers: []
    }
end

def addUserToMap(game, userName) do
     if(length(game.listOfUsers) != 5) do
          listUsers = game.listOfUsers ++ [userName];
          %{
              listOfUsers: listUsers
           }
     else
         %{
              listOfUsers: game.listOfUsers
          } 
     end
end

def client_view(game) do
    %{
      userName: "",
      listOfUsers: game.listOfUsers
    }
end

end

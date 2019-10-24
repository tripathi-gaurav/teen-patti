defmodule Teenpatti.Player do
    defstruct user_name: "", 
    money_available: 1000,
    hand: %{},
    is_show: false,
    is_turn: false,
    is_fold: false
end
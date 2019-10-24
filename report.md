# Teen Patti

### Team members: Gaurav Tripathi and Saurabh Bothra

#### Introduction and Game Description

#### UI
React-Konva to draw canvas and used canvas to display, users, cards and buttons.
Textbox

#### UI to Server
 - Textbox: userName
 - Textbox: Bet amount
 - Textbox: **Join** Table
 - Hidden element: `session_id` is sent to Server to uniquely identify a user.

##### Data structures on
- Main data structure to store player
  ```elixir
  defmodule Teenpatti.Player do
      defstruct user_name: "",
      money_available: 1000,
      hand: [],
      is_show: false,
      is_turn: false,
      is_fold: false,
      session_id: ""
  end
  ```
- *Server* stores list of players, and other variables internally and cleans it up
before sending it to the end user depending on the `session_id`.

#### Implementation of game

#### Challenges and Solutions
- Ranking
  - Trio
  - Straight flush/run
- Data structure
- Unique identifier (`session_id`)

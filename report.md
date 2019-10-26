# TEEN PATTI

**Authors**

- **Gaurav Tripathi**
- **Saurabh Bothra**

**Introduction and Game Description**

_Teen Patti_ (Hindi for Three Card Poker) is a well-known game and played in the
 Indian sub-continent region. An international 52 card pack is used, cards ranki
ng in the usual order from ace (high) down to two (low). Any reasonable number o
f players can take part; it is probably best for about 4 to 7 players. Before pl
aying it is necessary to agree the value of the minimum stake (which I will call
 one unit). Everyone places this minimum stake in the pot - a collection of mone
y in the center of the table, which will be won by one of the players. The deale
r deals out the cards one at a time until everyone has three cards. The players
then bet on who has the best three card hand. Each has the option to look at the
ir three-card hand before betting (playing  **seen** ) or to leave their cards f
ace down on the table (playing  **blind** ).

The ranking of hands is decided according to the following rules:

- **Three of kind (trio):** Three same cards, with three Aces being the highest
and three 2s being the lowest.
- **Straight flush:**  Three consecutive cards of the same suit. A-K-Q is the hi
ghest straight run. Next comes A-K-Q, 2-A-K, K-Q-J and so on down to 4-3-2, whic
h is the lowest.
- **Straight sequence:**  Three consecutive cards, not from the same suit. A-K-Q
 is the highest straight run. Next comes A-K-Q, 2-A-K, K-Q-J and so on down to 4
-3-2, which is the lowest.
- **Color flush:**  Three cards from the same suit. Ties are resolved by the fir
st high card.
- **Pair:**  Two cards of the same value. Pair with higher rank dominates. If a
tie still exists, then the value of third card decides the winner.
- **High card:**  First card with highest value determines the winner. If equal,
 then second high card is compared. If equal, then third high card is compared.

Below are definitions for some of the varying rules for our implementation:

The betting starts with the player to the left of the dealer, and continues with
 players taking turns in clockwise order around the table, for as many circuits
as are needed. Each player in turn can either put an additional bet into the pot
 to stay in, or pay nothing further and  **fold**. When folding you permanently
drop out of the betting and sacrifice any money you have already put into the po
t during that deal.

The amount that you have to put in at your turn in order to stay in the game dep
ends on the  **&quot;current stake&quot;** , and whether you are playing blind o
r seen - seen players have to bet twice as much as blind players to stay in. At
the start of the betting the current stake is one unit (i.e. the amount that eac
h player put in the pot as an ante).

- If you are a  **blind player**  (you have not looked at your cards), you must
put in at least the current stake and not more than twice the current stake. The
 current stake for the next player is then the amount that you put in.
- If you are a  **seen player**  you must bet at least  **twice**  the current s
take and not more than  **four times**  the current stake. The current stake for
 the next player becomes  **half**  the amount that you bet.

If you are a blind player, you may choose to look at your cards when your turn c
omes to bet. You then become a seen player and from that turn onwards you must b
et at least twice the current stake (or fold).

The betting continues in this way until one of the following things happens:

1. All except one player have folded. In that case the last surviving player win
s all the money in the pot, irrespective of the cards held.
2. All except two players have folded and one of these players at their turn pay
s for a  **show**. In that case the cards of both players are exposed and compar
ed.

The rules for a  **show**  are as follows:

- A show cannot occur until all but two players have dropped out.
- If you are a blind player, the cost of a show is the current stake, paid into
the pot, irrespective of whether the other player is blind or seen. You do not l
ook at your own cards until after you have paid for the show.
- If you are a seen player and the other player is blind, you are  **not allowed
**  to demand a show. The seen player can only continue betting or drop out.
- If both players are seen, either player in turn may pay twice the current stak
e for a show.
- In a show, both players&#39; cards are exposed, and the player whose hand is h
igher ranking wins the pot. If the hands are equal, the player who did  **not**
 pay for the show wins the pot.

If  **all**  the players are seen, then at your turn, immediately after betting
the minimum amount (twice the current stake), you can ask the player who bet imm
ediately before you for a **compromise (side show)**. That player can accept or
refuse the compromise.

- If the compromise is accepted, the two players involved privately compare thei
r cards, and the player with the lower ranking cards must immediately fold. If t
hey are equal, the player who asked for the compromise must fold.
- If the compromise is refused, the betting continues as usual with the player a
fter the one who asked for the compromise.

**UI Design**

The app starts by first showing the textbox where the player can enter the name
of the table he needs to join and a join game button which directs the player to
 the table he wishes to join. The player now enters his username in the game and
 his name is directly mapped to a person image. Once all users have entered the
table and typed in their username the game starts by clicking the start game but
ton.

We used React Know to create the UI. We created a green canvas to represent a ta
ble for the game. The person image represents each user joining the table. The b
uttons represent different functionality of the game like BET, SHOW, FOLD, SEEN.
 Each user is mapped with three cards. We are using card images to display the c
ards. For betting, we have created a textbox wherein the player can enter a vali
d bet value and click on the BET button to bet for his hand. We are also showing
 a chat box using text area element where the players can interact with each oth
er.

**UI To Server**

The server is keeping track of all the rules and calculations of the bet amounts
 for the game. First, we sent the name of the table joined by the player to the
server so that the state is changed and maintained for this table. Once we enter
 the game, the player registers by providing a username. A session ID is created
 for each username and it is sent to the server to uniquely identify the user. W
hen the player bets for a amount, the bet value is passed to the server and all
the calculations happen on the server side for pot money, current stake amount a
nd the player&#39;s money. When the user requests for a show, the user&#39;s dat
a is passed to the server so that it can uniquely identify the user who requeste
d for a show.

**Data Structures on Server**

We are using the following data structure on the server:

defmoduleTeenpatti.Playerdo

    defstructuser\_name:&quot;&quot;,

    money\_available:1000,

    hand: [],

    is\_show:false,

    is\_turn:false,

    is\_fold:false,

    session\_id:&quot;&quot;

end

We are creating a struct called **user\_name** has the following attributes in i
t:

- money\_available: this attribute keeps track of the money the player currently
 has.
- hand: this attribute represents a list of maps where each map stores the playe
r&#39;s card value, the type of card and the image location of that card.
- is\_show: this attribute represents a flag which indicates whether a player is
 eligible to request for a show. If true, the player is eligible to request for
a show, else not.
- is\_turn: this attribute represents a flag which indicates whether it&#39;s th
e player&#39;s turn to play. If true, then it&#39;s the player&#39;s turn, else
not.
- is\_fold: this attribute represents a flag which indicates whether the player
can quit the round. If true, then the player can quit the current round, else no
t.
- session\_id: this attribute represents a session id to uniquely identify the u
ser.

Server also stores information like list of players and other variables internal
ly and cleans it up before sending it to the end user depending on the **session
\_id.**

**Implementation of Game**

The game starts by first entering the name of the game. After that the player re
gisters in the game table by entering his user name and its unique session id is
 created. After all players have joined the game, the game starts by clicking th
e **start game**. After this button is clicked, a minimum amount ($10) is deduct
ed from each player&#39;s money and is added to pot. This minimum amount is set
as the current stake amount. Now the game has started and player1 is ready to pl
ay. The player can play as a seen player or a blind player. He needs to press th
e **play seen** button to play as a seen player, else the player will be playing
 as blind. Once the player presses this button, then the player can see his card
s. After that the player will add a bet money based on whether he is playing as
seen or blind and press the bet button. After that, the bet value will be deduct
ed from his money balance and the current stake amount and pot money will be acc
ordingly updated. The turn now will move to the next player who will follow the
same process. If the player thinks that his cards aren&#39;t good enough to win
then he can press the **fold** button and back out from this round. The game wil
l continue until two are left on the table. After that, any of the two players c
an call for a show by pressing the **show** button and the appropriate winner wi
ll be displayed based on the ranking of the hands. Also the pot money will be ad
ded to the winner&#39;s money balance. We have also implemented a chatbox where 
players can interact with each other.

**Challenges and Solutions**

- **Ranking of Cards:**

This was one of the biggest challenges in the game. We had to come up with a log
ic to decide which player&#39;s hand is bigger and the winner is decided based o
n the ranking of the hands. We created a complex if-else structure which returns
 the player who won the round based on the ranking of hands.

The ranking of hands is decided according to the following rules:

-
  - **Three of kind (trio):** Three same cards, with three Aces being the highes
t and three 2s being the lowest.
  - **Straight flush:**  Three consecutive cards of the same suit. A-K-Q is the
highest straight run. Next comes A-K-Q, 2-A-K, K-Q-J and so on down to 4-3-2, wh
ich is the lowest.
  - **Straight sequence:**  Three consecutive cards, not from the same suit. A-K
-Q is the highest straight run. Next comes A-K-Q, 2-A-K, K-Q-J and so on down to
 4-3-2, which is the lowest.
  - **Color flush:**  Three cards from the same suit. Ties are resolved by the f
irst high card. If all card values are same, then suits are ranked from Spades \
&gt; Diamond \&gt; Heart \&gt; Clubs.
  - **Pair:**  Two cards of the same value. Pair with higher rank dominates. If
a tie still exists, then the value of third card decides the winner. If the game
 is still tied, ranking of suits determines the winner (Spades \&gt; Diamond \&g
t; Heart \&gt; Clubs).
  - **High card:**  First card with highest value determines the winner. If equa
l, then second high card is compared. If equal, then third high card is compared
. If the game is tied, then ranking of card suit determines the winner (Spades \
&gt; Diamond \&gt; Heart \&gt; Clubs
- **Creating Data Structure:**

We had to figure out a way to store each player&#39;s money and hand information
 and the other flags associated with the player. We created a map of struct wher
e each struct represents a player and all the attributes associated with the pla
yer. We also have a map for storing the hands of a player which is one of the at
tributes of the **struct player**.

- **Identifying players uniquely:**

We had to figure out a way to identify players uniquely which was necessary whil
e performing calculations on the player&#39;s money and storing the hand informa
tion. We created the session id by using the **crypto** module of elixir.

** **

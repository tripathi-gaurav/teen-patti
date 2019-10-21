import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';


export default function game_init(root, channel) {
  ReactDOM.render(<TeenPatti channel={channel}/>, root);
}

class TeenPatti extends React.Component {


constructor(props) {

    super(props);
    this.channel = props.channel;
    this.state = {
	userName:  "",
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
	isBlindPlayer1: false,
	isBlindPlayer2: false,
	isSeenPlayer1: false,
	isSeenPlayer2: false,
	turn: 0
    };  
  

    this.channel.join()
          .receive("ok", resp => {
           console.log("Successfully joined");
           this.got_view(resp);
          })
       .receive("error", resp => {console.log("Unable to join", resp);});


}


got_view(view) {
     console.log("new view", view);
     this.setState(view.game);
}



handleChange(value) {
     this.setState({userName: value});
}

onClickJoinGameButton() {

this.channel.push("join_game", {userName: this.state.userName})
                   .receive("ok", resp => {this.got_view(resp);});

}


render() {
	
   let message = "";
   let player1Name = "";
   let player2Name = "";
   let size = this.state.listOfUsers.length;
   console.log( "size= " + size );

   if( size != 0){
       for (var i = 0; i <size; i++) {
               message = message + "\n" + this.state.listOfUsers[i];
       }
   } 
   if( size >= 2) {
       player1Name = this.state.listOfUsers[0];
       player2Name = this.state.listOfUsers[1];
   }

   return(
	
       <div className = "mainboard">

       <div className="userList">

           Enter Your Name:  <input id = "tb1" type = "text" value = {this.state.userName} onChange={(e) =>this.handleChange(e.target.value)}/>
	   <button className = "b1" onClick={() => this.onClickJoinGameButton()}>Join {window.gameName}</button>
           <p>Following users joined successfully: {message}</p>
       </div>

       <div className = "board">
	   <div class = "start">
               <button className = "start">Start Game</button><br /> 
	   </div>
           <div className = "player1">
	       <p>Name: {player1Name}</p>
	       <button className = "hand1"></button>
	       <button className = "hand2"></button>
	       <button className = "hand3"></button>
	       <button className = "money">Amount: {this.state.moneyPlayer1}</button>
	       <button className = "fold">Fold</button>
	       <button className = "bet">Bet</button>
	       <button className = "blind">Play Blind</button>
	       <button className = "seen">Play Seen</button>
	   </div>
	   <div className = "player2">
               <p>Name: {player2Name}</p>
	       <button className = "hand1"></button>
	       <button className = "hand2"></button>
	       <button className = "hand3"></button>
	       <button className = "money">Amount: {this.state.moneyPlayer2}</button>
	       <button className = "fold">Fold</button>
	       <button className = "bet">Bet</button>
	       <button className = "blind">Play Blind</button>
	       <button className = "seen">Play Seen</button>
	   </div>
	   <div className = "show">
               <button className = "show">Show</button><br />
	   </div>	   
	   <div className = "potAmount">
               <p>Pot Amount: {this.state.potMoney}</p>
	   </div>
	   <div className = "currentStakeAmount">
               <p>Current Stake Amount: {this.state.currentStakeAmount}</p>
	   </div>

       </div>
       </div>



   );

 }
}


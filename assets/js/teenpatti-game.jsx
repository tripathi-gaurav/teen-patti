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
	isSeenPlayer1: false,
	isSeenPlayer2: false,
	turn: 0,
	betValuePlayer1: 0,
	betValuePlayer2: 0,
	message1: "",
	message2: ""
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

handleBetForPlayer1(value) {
     this.setState({betValuePlayer1: parseInt(value)});
}

handleBetForPlayer2(value) {
     this.setState({betValuePlayer2: parseInt(value)});
}

onClickJoinGameButton() {
this.channel.push("join_game", {userName: this.state.userName})
                   .receive("ok", resp => {this.got_view(resp);});
}

startGame() {
   this.channel.push("start_game", {})
                   .receive("ok", resp => {this.got_view(resp);});
}

onClickSeen() {
       this.channel.push("change_seen", {turn: this.state.turn})
                   .receive("ok", resp => {this.got_view(resp);});
       this.channel.push("assign_cards", {turn: this.state.turn})
                   .receive("ok", resp => {this.got_view(resp);});
}

onClickBet() {
  if(this.state.turn == 1 && this.state.isBetPlayer1) {
         if(this.state.isSeenPlayer1) { 
		 if(this.state.betValuePlayer1 >= 2*this.state.currentStakeAmount && this.state.betValuePlayer1 <= 4*this.state.currentStakeAmount) {
                             this.channel.push("click_bet_seen", {turn: this.state.turn, betValue: this.state.betValuePlayer1})
                       .receive("ok", resp => {this.got_view(resp);});
		 }
	 } else {
                if(this.state.betValuePlayer1 >= this.state.currentStakeAmount && this.state.betValuePlayer1 <= 2*this.state.currentStakeAmount) {
                             this.channel.push("click_bet_blind", {turn: this.state.turn, betValue: this.state.betValuePlayer1})
                   .receive("ok", resp => {this.got_view(resp);});
		}
	 }
  }
  if(this.state.turn == 2 && this.state.isBetPlayer2) {
         if(this.state.isSeenPlayer2) {
                 if(this.state.betValuePlayer2 >= 2*this.state.currentStakeAmount && this.state.betValuePlayer2 <= 4*this.state.currentStakeAmount) {
                             this.channel.push("click_bet_seen", {turn: this.state.turn, betValue: this.state.betValuePlayer2})
                   .receive("ok", resp => {this.got_view(resp);});

		 }
	 } else {
                 if(this.state.betValuePlayer2 >= this.state.currentStakeAmount && this.state.betValuePlayer2 <= 2*this.state.currentStakeAmount) {
                             this.channel.push("click_bet_blind", {turn: this.state.turn, betValue: this.state.betValuePlayer2})
                   .receive("ok", resp => {this.got_view(resp);});
		 }
	 }
  }
}

onClickFold() {



}
	  
handValue(index, turn) {
    if(this.state.handForPlayer1.length == 0) {
        return ("");
    }
    if(this.state.isSeenPlayer1 && turn == 1) {
        return (this.state.handForPlayer1[index].value + " : " + this.state.handForPlayer1[index].type);
    }
    if(this.state.handForPlayer2.length == 0) {
        return ("");
    }
    if(this.state.isSeenPlayer2 && turn == 2) {
        return (this.state.handForPlayer2[index].value + " : " + this.state.handForPlayer2[index].type);
    }
    return ("");
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

       <div className = "userList">

           Enter Your Name:  <input id = "tb1" type = "text" value = {this.state.userName} onChange={(e) =>this.handleChange(e.target.value)}/>
	   <button className = "b1" onClick={() => this.onClickJoinGameButton()}>Join {window.gameName}</button>
           <p>Following users joined successfully: {message}</p>
       </div>

       <div className = "board">
	   <div class = "start">
               <button className = "start" onClick={() => this.startGame()}>Start Game</button><br /> 
	   </div>
           <div className = "player1">
	       <p>Name: {player1Name}</p>
	       <p>Money: {this.state.moneyPlayer1}</p>
	       <button className = "hand1">{this.handValue(0,1)}</button>
	       <button className = "hand2">{this.handValue(1,1)}</button>
	       <button className = "hand3">{this.handValue(2,1)}</button>
	       <button className = "money">Amount: {this.state.moneyPlayer1}</button>
	       <button className = "fold" onClick={() => this.onClickFold()}>Fold</button>
	       <button className = "seen" onClick={() => this.onClickSeen()}>Play Seen</button><br />
	       <input id = "tb2" type = "text" value = {this.state.betValuePlayer1} onChange={(e) => this.handleBetForPlayer1(e.target.value)}/><br />
	       <button className = "bet" onClick={() => this.onClickBet()}>Bet</button><br />
	       <p>{this.state.message1}</p>
	   </div>
	   <hr />
	   <div className = "player2">
               <p>Name: {player2Name}</p>
	       <p>Money: {this.state.moneyPlayer2}</p>
	       <button className = "hand1">{this.handValue(0,2)}</button>
	       <button className = "hand2">{this.handValue(1,2)}</button>
	       <button className = "hand3">{this.handValue(2,2)}</button>
	       <button className = "money">Amount: {this.state.moneyPlayer2}</button>
	       <button className = "fold" onClick={() => this.onClickFold()}>Fold</button>
	       <button className = "seen" onClick={() => this.onClickSeen()}>Play Seen</button>
	       <input id = "tb3" type = "text" value = {this.state.betValuePlayer2} onChange={(e) =>this.handleBetForPlayer2(e.target.value)}/><br />
	       <button className = "bet" onClick={() => this.onClickBet()}>Bet</button>
	       <p>{this.state.message2}</p>
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


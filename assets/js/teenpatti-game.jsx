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
	listOfUsers: []    
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
   let size = this.state.listOfUsers.length;
   console.log( "size= " + size );

   if( size != 0 ){
       for (var i = 0; i <size; i++) {
               message = message + "\n" + this.state.listOfUsers[i];
       }
   }

   return(
	
       <div className = "mainboard">

       <div className="userList">

           Enter Your Name:  <input id = "tb1" type = "text" value = {this.state.userName} onChange={(e) =>this.handleChange(e.target.value)}/>
	   <button className = "b1" onClick={() => this.onClickJoinGameButton()}>Join {window.gameName}</button>

       </div>

       <div className = "board">
            <p>Following users joined successfully: {message}</p>

       </div>
       </div>



   );

 }
}


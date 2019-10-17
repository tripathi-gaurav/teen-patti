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
    this.state = {};  
  

    this.channel.join()
         .receive("ok", resp => {
          console.log("Successfully joined");
          this.got_view(resp);
         })  
      .receive("error", resp => {console.log("Unable to join", resp);});

}

render() {


   return(

       <div className = "board">
            <h1>Welcome To Teen Patti Table!</h1>

       </div>



   );



 }
}


import React from "react";
import ReactDOM from "react-dom";
import _ from "lodash";
import { Stage, Layer, Rect, Image, Text } from "react-konva";
import useImage from 'use-image';
import $ from 'jquery'

export default function game_init(root, channel) {
    ReactDOM.render(<Table channel={channel} />, root);
}


let table_width = 768;
let table_height = 550;
let W = 1024;
let H = 600;
let table_color = "#92e569";
let pos_x = 20;
let pos_y = 20;
let corner_radius = 100;
let R = 50;
let G = 2;

class Table extends React.Component {
    constructor(props) {
        super(props);
        //this.state = props.state;
        //this.channel = props.channel;
        this.channel = props.channel;
        this.state = {
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
            message2: "",
            list_of_players: [],
            players: [],
            player: {}
        };



        if (this.player) {
            this.channel
                .join()
                .receive("ok", resp => {
                    console.log("Successfully joined");
                    this.got_view(resp);
                })
                .receive("error", resp => {
                    console.log("Unable to join", resp);
                });
        } else {
            this.channel
                .join()
                .receive("ok", resp => {
                    console.log("Successfully joined");
                    this.got_view(resp);
                })
                .receive("error", resp => {
                    console.log("Unable to join", resp);
                });
        }
        this.channel.on("refresh_view", resp => {
            console.log("refresh_view broadcast");
            this.refresh_view(resp);
        });

        this.channel.on("chat", resp => {
            console.log("chat broadcast");
            this.chat_arrived(resp.message);
        });

        this.channel.on("final_view", resp => {
            console.log("final_view broadcast");
            this.refresh_view_final(resp);
        });
    }



    render_user(x, y) {
        //console.log("rendering user at: " + x + " " + y);
        const UserImage = () => {
            const [image] = useImage('/images/user_images/user.png');
            return <Image image={image}
                x={x}
                y={y}
                width={100}
                height={100}
            />;
        };
        return (<UserImage />);
    }

    render_cards_for_user(type, value, x, y) {
        if (type === "Spades")
            type = "spade"
        else if (type === "Hearts")
            type = "Heart"
        else if (type === "Diamonds")
            type = "Diamond"
        else if (type === "Clubs")
            type = "club"

        if (value == 14)
            value = "A"
        else if (value == 13)
            value = "K"
        else if (value == 12)
            value = "Q"
        else if (value == 11)
            value = "J"

        let image_name = type + "_" + value + ".png";
        let CardImage = () => {
            let [image] = useImage('/images/PNG/Cards/' + image_name);
            return <Image image={image}
                x={x}
                y={y}
                width={50}
                height={75}
            />;
        };
        return (<CardImage />);
    }

    render_text(text, x, y) {
        return (<Text
            x={x}
            y={y}
            text={text}
            fontFamily={'Calibri'}
            fontSize={18}
            align={'center'}

        />);
    }

    render_text_with_on_click(text, x, y) {
        return (<Text
            x={x}
            y={y}
            text={text}
            fontFamily={'Calibri'}
            fontSize={18}
            align={'center'}
            onClick={() => this.handle_click(text)}

        />);
    }

    render_rect_with_on_click(label, x, y, color) {
        var text = this.render_text_with_on_click(label, x + 50, y + 15);
        let border = (<Rect
            x={x}
            y={y}
            width={150}
            height={50}
            cornerRadius={20}
            fill={color}
            stroke={'black'}
            shadowBlur={5}
            onClick={() => this.handle_click(label)}
        />);
        let btn = [];
        btn.push(border);
        btn.push(text);
        return (btn);
    }

    // ----------------------- START OF ON CLICK COPY OVER --------------------------- //

    handle_click(btn) {
        console.log(btn);
        if (btn == "Fold") {
            console.log(" folding.. ");
            return this.onClickFold();
        } else if (btn == "See Cards") {
            console.log(" see.. ");
            return this.onClickSeen();
        } else if (btn == "BET") {
            console.log("BET");
            return this.onClickBet();
        } else if (btn == "Start Game") {
            console.log("..start..");
            return this.startGame();
        } else if (btn == "Reset") {
            console.log("!! RESET !! ");
            return this.reset_game();
        } else if (btn == "SHOW") {
            console.log("== SHOW == ");
            return this.onClickShow();
        }
    }

    reset_game() {
        this.channel.push("reset_game", {}).receive("ok", resp => {
            this.got_view(resp);
        });
    }

    refresh_view(view) {
        console.log(view);
        console.log("session_id: " + this.state.player.session_id); //hash of userName

        if (this.state.player.session_id != "") {
            this.channel
                .push("refresh_view", { userName: this.state.player.session_id, gameName: view.resp })
                .receive("ok", resp => {
                    console.log(" refresh: " + resp);
                    this.got_view(resp.game);
                });
        }
    }

    chat_arrived(resp) {
        console.log("arrive: " + resp);
        let chat_history = document.getElementById('chatBox').value;
        console.log("history: " + chat_history);
        document.getElementById('chatBox').value = chat_history + "\n" + resp;

        //atribution: https://stackoverflow.com/questions/9170670/how-do-i-set-textarea-scroll-bar-to-bottom-as-a-default#9170709
        var textarea = document.getElementById('chatBox');
        textarea.scrollTop = textarea.scrollHeight;
    }
    refresh_view_final(view) {
        console.log(view);
        console.log("session_id: " + this.state.player.session_id); //hash of userName

        if (this.state.player.session_id != "") {
            this.channel
                .push("refresh_view_final", { userName: this.state.player.session_id, gameName: view.resp })
                .receive("ok", resp => {
                    console.log(" refresh: " + resp);
                    this.got_view(resp.game);
                });
        }
    }

    got_view(view) {
        console.log("new view", view);
        if (view.game) {
            this.setState(view.game);
            if (view.game.message1 != "") {
                alert(view.game.message1);
            }
        } else {
            console.log("directly setting the state");
            this.setState(view);
            if (view.message1 != "") {
                alert(game.message1);
            }
        }
    }

    handleChange(value) {
        this.setState({ userName: value });
    }

    onClickJoinGameButton() {
        this.channel
            .push("join_game", { userName: this.state.userName })
            .receive("ok", resp => {
                this.got_view(resp);
            });
    }

    startGame() {
        if (this.state.potMoney > 0) {
            alert("Game already on");
            return;
        }
        this.channel.push("start_game", { userName: this.state.player.session_id }).receive("ok", resp => {
            this.got_view(resp);
        });
    }

    onClickSeen() {
        if (this.state.potMoney == 0) {
            alert("Game not started. First click start.");
            return;
        }
        if (!this.state.player.is_turn) {
            alert("Not your turn. ");
            return;
        }
        let turn = this.state.player.session_id;
        console.log("seeing cards: " + turn);
        this.channel
            .push("see_cards", { userName: this.state.player.session_id })
            .receive("ok", resp => {
                this.got_view(resp);
            });

    }

    onClickBet() {
        if (this.state.potMoney == 0) {
            alert("Game not started. First click start.");
            return;
        }
        let bet_amount = parseInt(document.getElementById("tb2").value);
        let _user_session = this.state.player.session_id;
        console.log("betting user: " + _user_session);
        console.log("bet amount: " + bet_amount);
        let is_seen = this.state.player.is_seen;
        let is_turn = this.state.player.is_turn;

        if (!is_turn) {
            alert("Not your turn. ");
            return;
        }

        // TODO: reverse the boolean logic to channel.push only once
        if (is_seen &&
            bet_amount >= 2 * this.state.currentStakeAmount &&
            bet_amount <= 4 * this.state.currentStakeAmount
        ) {

            this.channel
                .push("click_bet_seen", {
                    turn: _user_session,
                    betValue: bet_amount
                })
                .receive("ok", resp => {
                    this.got_view(resp);
                });
        } else if (bet_amount >= this.state.currentStakeAmount &&
            bet_amount <= 2 * this.state.currentStakeAmount
        ) {
            this.channel
                .push("click_bet_seen", {
                    turn: _user_session,
                    betValue: bet_amount
                })
                .receive("ok", resp => {
                    this.got_view(resp);
                });
        } else {
            alert('Enter valid amt. Blind player max: 2*stake amt. Seen max: 4*stake amt.')
        }


    }

    onClickFold() {
        if (this.state.potMoney == 0) {
            alert("Game not started. First click start.");
            return;
        }
        if (!this.state.player.is_turn) {
            alert("Not your turn. ");
            return;
        }
        this.channel
            .push("click_fold", { turn: this.state.player.session_id })
            .receive("ok", resp => {
                this.got_view(resp);
            });
    }

    handValue(index, turn) {
        if (this.state.handForPlayer1.length == 0) {
            return "";
        }
        if (this.state.isSeenPlayer1 && turn == 1) {
            return (
                this.state.handForPlayer1[index].value +
                " : " +
                this.state.handForPlayer1[index].type
            );
        }
        if (this.state.handForPlayer2.length == 0) {
            return "";
        }
        if (this.state.isSeenPlayer2 && turn == 2) {
            return (
                this.state.handForPlayer2[index].value +
                " : " +
                this.state.handForPlayer2[index].type
            );
        }
        return "";
    }

    onClickChat() {
        let text = document.getElementById('txtChat').value;
        if (text == "") {
            return;
        }
        text = this.state.player.session_id + ": " + text
        console.log(text);
        this.channel.push("chat", { message: text }).receive("ok", resp => {
            //this.got_view(resp);
            console.log("resp for chat: " + resp);
        });
    }

    onClickShow() {
        if (this.state.potMoney == 0) {
            alert("Game not started. First click start.");
            return;
        }
        if (!this.state.isShow && this.state.listOfUsers.length >= 2) {
            // this.channel
            //     .push("change_show", { turn: this.state.turn })
            //     .receive("ok", resp => {
            //         this.got_view(resp);
            //     });
            let is_seen = this.state.player.is_seen;
            let is_turn = this.state.player.is_turn;

            if (!is_turn) {
                alert("Not your turn.");
                return;
            }
            let list_of_players = this.players;
            if (is_seen) {
                let list_of_players = this.state.players;
                for (let i = 0; i < list_of_players.length; i++) {
                    if (!list_of_players[i].is_seen) {
                        alert("Other player is blind. You can't call for show");
                        return;
                    }
                }

                this.channel
                    .push("evaluate_show", { turn: this.state.player.session_id })
                    .receive("ok", resp => {
                        this.got_view(resp);
                    });
            } else {
                this.channel
                    .push("evaluate_show", { turn: this.state.player.session_id })
                    .receive("ok", resp => {
                        this.got_view(resp);
                    });
            }

        }
    }

    // ----------------------- END OF ON CLICK COPY OVER --------------------------- //



    render() {
        // var listOfUsers = this.props.listOfUsers;
        // var handForPlayer1 = this.props.handForPlayer1;
        // var handForPlayer2 = this.props.handForPlayer2;
        // var moneyPlayer1 = this.props.state.moneyPlayer1;
        // var moneyPlayer2 = this.props.state.moneyPlayer2;
        // var userName = this.props.state.userName;
        // var message1 = this.props.state.message1;
        // var message2 = this.props.state.message2;

        var listOfUsers = this.state.listOfUsers;
        var handForPlayer1 = this.state.handForPlayer1;
        var handForPlayer2 = this.state.handForPlayer2;
        var moneyPlayer1 = this.state.moneyPlayer1;
        var moneyPlayer2 = this.state.moneyPlayer2;
        var userName = this.state.userName;
        var message1 = this.state.message1;
        var message2 = this.state.message2;


        var list_of_players = this.state.players;
        var my_player = this.state.player;

        let message = "";
        let player1Name = "";
        let player2Name = "";
        let size = this.state.listOfUsers.length;
        console.log("size= " + size);

        if (size != 0) {
            for (var i = 0; i < size; i++) {
                message = message + "\n" + this.state.listOfUsers[i];
            }
        }
        if (size >= 2) {
            player1Name = this.state.listOfUsers[0];
            player2Name = this.state.listOfUsers[1];
        }

        let table = (
            <Rect
                x={pos_x}
                y={pos_y}
                width={table_width}
                height={table_height}
                cornerRadius={corner_radius}
                fill={table_color}
                stroke="black"
                shadowBlur={5}

            />
        );
        console.log("table done");

        // this.state.handForPlayer1[index].value +
        // " : " +
        // this.state.handForPlayer1[index].type

        let my_x = pos_x;

        var users = [];
        var userName = [];
        var cards = [];
        var moolah = [];
        var fold_buttons = [];
        var seen_buttons = [];
        var bet_button = [];
        var message_text = [];

        console.log("enemy at the gate: " + list_of_players);
        for (var i = 0; i < list_of_players.length; i++) {
            console.log("atempting to create user " + i);
            users.push(this.render_user(my_x, pos_y));

            let curr_player = list_of_players[i];
            userName.push(this.render_text("U:" + curr_player.user_name, my_x, pos_y + 200));
            var _length = 3;    //curr_player.length
            for (var j = 0; j < _length; j++) {
                if (curr_player.is_seen && curr_player.hand != null && curr_player.hand.length > 0) {
                    cards.push(this.render_cards_for_user(curr_player.hand[j].type, curr_player.hand[j].value, my_x + (j * 50), pos_y + 110));
                } else {
                    cards.push(this.render_cards_for_user("Background", "Black", my_x + (j * 10), pos_y + 110));
                }
            }

            //userName.push(this.render_text("U:" + userName, my_x, pos_y + 210));
            moolah.push(this.render_text("Amount: $" + curr_player.money_available, my_x, pos_y + 220));
            message_text.push(this.render_text("", my_x, pos_y + 230)); //message_text.push(this.render_text(message1, my_x, pos_y + 230));




            my_x = my_x + 275;
        }
        my_x = 200;

        let my_y = pos_y + 400
        if (list_of_players.length > 0) {
            fold_buttons.push(this.render_rect_with_on_click("Fold", my_x, pos_y + 300, "#f7ab38"));
            seen_buttons.push(this.render_rect_with_on_click("See Cards", my_x + 150, pos_y + 300, '#9b4dca'));
            bet_button.push(this.render_rect_with_on_click("BET", my_x + 300, pos_y + 300, "#0b7ebc"));
            var start_btn = this.render_rect_with_on_click("Start Game", my_x, my_y, "#413fb5");
            var show_btn = this.render_rect_with_on_click("SHOW", my_x + 75, my_y + 75, "#f74b38");
            var pot_amt_btn = this.render_text("Pot Amount: $" + this.state.potMoney, my_x + 310, my_y);
            var current_stake_amount = this.render_text("Current Stake Amount: $" + this.state.currentStakeAmount, my_x + 310, my_y + 50);
        }
        var reset_btn = this.render_rect_with_on_click("Reset", my_x + 150, my_y, "#f74b38");


        $(document).ready(function () {
            //attribution: https://stackoverflow.com/questions/6542413/bind-enter-key-to-specific-button-on-page
            $('#txtChat').show().unbind('keypress')
            $('body').on('keypress', '#txtChat', function (args) {
                if (args.keyCode == 13) {

                    $('#btnChat').click();
                    return;
                }
            });

        });



        return (
            <div className="mainboard">
                <div className="userList">
                    <input type="hidden" id="session_id" value={this.state.session_id} />
                    Enter Your Name:{" "}
                    <input
                        id="tb1"
                        type="text"
                        value={this.state.userName}
                        onChange={e => this.handleChange(e.target.value)}
                    />
                    <button className="b1" onClick={() => this.onClickJoinGameButton()}>
                        Join {window.gameName}
                    </button>
                    <p>Players on this table: {message}</p>
                </div>

                <div>
                    <Stage width={W} height={H}>
                        <Layer>{table}{users}{userName}{cards}
                            {moolah}{fold_buttons}{seen_buttons}{bet_button}
                            {message_text}
                            {start_btn}
                            {reset_btn}
                            {show_btn}
                            {pot_amt_btn}
                            {current_stake_amount}
                        </Layer>
                    </Stage>
                </div>

                <input
                    id="tb2"
                    type="text"
                    placeholder="enter bet amount here"
                />

                <fieldset>
                    <label>Chat</label>
                    <textarea id="chatBox" rows="1000" cols="100" />
                    <input id="txtChat" type="text" placeholder="enter chat text here" />
                </fieldset>

                <button id="btnChat" onClick={() => this.onClickChat()}>
                    Send chat message!
                </button>

            </div>

        );
    }
}


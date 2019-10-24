import React from "react";
import ReactDOM from "react-dom";
import _ from "lodash";
import { Stage, Layer, Rect, Image, Text } from "react-konva";
import useImage from 'use-image';

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
            message2: ""
        };

        this.channel
            .join()
            .receive("ok", resp => {
                console.log("Successfully joined");
                this.got_view(resp);
            })
            .receive("error", resp => {
                console.log("Unable to join", resp);
            });
        // this.state = {
        //   balls: [
        //     { x: 100, y: 700, dx: 0, dy: -1 },
        //     { x: 200, y: 650, dx: 0, dy: -1 },
        //     { x: 300, y: 750, dx: 0, dy: -1 }
        //   ]
        // };

        //window.setInterval(this.tick.bind(this), 50);
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

    render_rect_with_on_click(label, x, y, color) {
        var text = this.render_text(label, x + 50, y + 15);
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

    // onClickFold() {
    //     console.log("sending fold");
    //     this.channel
    //         .push("click_fold", { turn: this.state.turn })
    //         .receive("ok", resp => {
    //             this.got_view(resp);
    //         });
    // }

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

    got_view(view) {
        console.log("new view", view);
        this.setState(view.game);
    }

    handleChange(value) {
        this.setState({ userName: value });
    }

    handleBetForPlayer1(value) {
        this.setState({ betValuePlayer1: parseInt(value) });
    }

    handleBetForPlayer2(value) {
        this.setState({ betValuePlayer2: parseInt(value) });
    }

    onClickJoinGameButton() {
        this.channel
            .push("join_game", { userName: this.state.userName })
            .receive("ok", resp => {
                this.got_view(resp);
            });
    }

    startGame() {
        this.channel.push("start_game", {}).receive("ok", resp => {
            this.got_view(resp);
        });
    }

    onClickSeen() {
        // this.channel
        //     .push("change_seen", { turn: this.state.turn })
        //     .receive("ok", resp => {
        //         this.got_view(resp);
        //     });
        this.channel
            .push("assign_cards", { turn: this.state.turn })
            .receive("ok", resp => {
                this.got_view(resp);
            });
    }

    onClickBet() {
        console.log(this.state.turn + " && " + this.state.isBetPlayer1);
        if (this.state.turn == 1 && this.state.isBetPlayer1) {
            if (this.state.isSeenPlayer1) {
                if (
                    this.state.betValuePlayer1 >= 2 * this.state.currentStakeAmount &&
                    this.state.betValuePlayer1 <= 4 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_seen", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer1
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            } else {
                if (
                    this.state.betValuePlayer1 >= this.state.currentStakeAmount &&
                    this.state.betValuePlayer1 <= 2 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_blind", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer1
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            }
        }
        if (this.state.turn == 2 && this.state.isBetPlayer2) {
            if (this.state.isSeenPlayer2) {
                if (
                    this.state.betValuePlayer2 >= 2 * this.state.currentStakeAmount &&
                    this.state.betValuePlayer2 <= 4 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_seen", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer2
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            } else {
                if (
                    this.state.betValuePlayer2 >= this.state.currentStakeAmount &&
                    this.state.betValuePlayer2 <= 2 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_blind", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer2
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            }
        }
    }

    onClickFold() {
        this.channel
            .push("click_fold", { turn: this.state.turn })
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

    onClickShow() {
        if (!this.state.isShow && this.state.listOfUsers.length == 2) {
            this.channel
                .push("change_show", { turn: this.state.turn })
                .receive("ok", resp => {
                    this.got_view(resp);
                });
            if (this.state.turn == 1) {
                if (this.state.isSeenPlayer1) {
                    this.channel
                        .push("evaluate_show_seen", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                } else {
                    this.channel
                        .push("evaluate_show_blind", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            } else {
                if (this.state.isSeenPlayer2) {
                    this.channel
                        .push("evaluate_show_seen", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                } else {
                    this.channel
                        .push("evaluate_show_blind", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
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


        for (var i = 0; i < listOfUsers.length; i++) {
            console.log("atempting to create user " + i);
            users.push(this.render_user(my_x, pos_y));


            var _length = 3;    //handForPlayer1.length
            if (i == 0) {
                console.log("handForPlayer1 len: " + handForPlayer1.length);
                for (var j = 0; j < _length; j++) {
                    if (handForPlayer1.length > 0) {
                        cards.push(this.render_cards_for_user(handForPlayer1[j].type, handForPlayer1[j].value, my_x + (j * 50), pos_y + 110));
                    } else {
                        cards.push(this.render_cards_for_user("Background", "Black", my_x + (j * 10), pos_y + 110));
                    }
                }
            }
            if (i == 1) {
                //j = 0;
                console.log("handForPlayer2 len: " + handForPlayer2.length);
                for (var j = 0; j < _length; j++) {
                    //console.log(j + ": " + handForPlayer2[j].type + " " + handForPlayer2[j].value);
                    if (handForPlayer2.length > 0) {
                        cards.push(this.render_cards_for_user(handForPlayer2[j].type, handForPlayer2[j].value, my_x + (j * 50), pos_y + 110));
                    } else {
                        cards.push(this.render_cards_for_user("Background", "Black", my_x + (j * 10), pos_y + 110));
                    }
                }
            }

            //userName.push(this.render_text("U:" + userName, my_x, pos_y + 210));

            if (i == 0) {

                moolah.push(this.render_text("Amount: $" + moneyPlayer1, my_x, pos_y + 220));
                message_text.push(this.render_text(message1, my_x, pos_y + 230));
            }
            else if (i == 1) {
                moolah.push(this.render_text("Amount: $" + moneyPlayer2, my_x, pos_y + 220));
                message_text.push(this.render_text(message2, my_x, pos_y + 230));
            }

            fold_buttons.push(this.render_rect_with_on_click("Fold", my_x, pos_y + 250, "#f7ab38"));
            seen_buttons.push(this.render_rect_with_on_click("See Cards", my_x, pos_y + 275, '#9b4dca'));
            bet_button.push(this.render_rect_with_on_click("BET", my_x, pos_y + 310, "#0b7ebc"))


            my_x = my_x + 275;
        }
        my_x = 200;
        let my_y = pos_y + 400
        let start_btn = this.render_rect_with_on_click("Start Game", my_x, my_y, "#413fb5");
        let reset_btn = this.render_rect_with_on_click("Reset", my_x + 150, my_y, "#f74b38");
        let show_btn = this.render_rect_with_on_click("SHOW", my_x + 75, my_y + 75, "#f74b38");
        let pot_amt_btn = this.render_text("Pot Amount: $" + this.state.potMoney, my_x, my_y + 100);
        let current_stake_amount = this.render_text("Current Stake Amount: $" + this.state.currentStakeAmount, my_x, my_y + 150);
        return (
            <div className="mainboard">
                <div className="userList">

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
                    <p>Following users joined successfully: {message}</p>
                </div>

                <div>
                    <Stage width={W} height={H}>
                        <Layer>{table}{users}{cards}{userName}
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
                    value={this.state.betValuePlayer1}
                    onChange={e => this.handleBetForPlayer1(e.target.value)}
                />
                <input
                    id="tb3"
                    type="text"
                    value={this.state.betValuePlayer2}
                    onChange={e => this.handleBetForPlayer2(e.target.value)}
                />

            </div>

        );
    }
}

class TeenPatti extends React.Component {
    constructor(props) {
        super(props);
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
            message2: ""
        };

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

    got_view(view) {
        console.log("new view", view);
        this.setState(view.game);
    }

    handleChange(value) {
        this.setState({ userName: value });
    }

    handleBetForPlayer1(value) {
        this.setState({ betValuePlayer1: parseInt(value) });
    }

    handleBetForPlayer2(value) {
        this.setState({ betValuePlayer2: parseInt(value) });
    }

    onClickJoinGameButton() {
        this.channel
            .push("join_game", { userName: this.state.userName })
            .receive("ok", resp => {
                this.got_view(resp);
            });
    }

    startGame() {
        this.channel.push("start_game", {}).receive("ok", resp => {
            this.got_view(resp);
        });
    }

    onClickSeen() {
        this.channel
            .push("change_seen", { turn: this.state.turn })
            .receive("ok", resp => {
                this.got_view(resp);
            });
        this.channel
            .push("assign_cards", { turn: this.state.turn })
            .receive("ok", resp => {
                this.got_view(resp);
            });
    }

    onClickBet() {
        if (this.state.turn == 1 && this.state.isBetPlayer1) {
            if (this.state.isSeenPlayer1) {
                if (
                    this.state.betValuePlayer1 >= 2 * this.state.currentStakeAmount &&
                    this.state.betValuePlayer1 <= 4 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_seen", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer1
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            } else {
                if (
                    this.state.betValuePlayer1 >= this.state.currentStakeAmount &&
                    this.state.betValuePlayer1 <= 2 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_blind", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer1
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            }
        }
        if (this.state.turn == 2 && this.state.isBetPlayer2) {
            if (this.state.isSeenPlayer2) {
                if (
                    this.state.betValuePlayer2 >= 2 * this.state.currentStakeAmount &&
                    this.state.betValuePlayer2 <= 4 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_seen", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer2
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            } else {
                if (
                    this.state.betValuePlayer2 >= this.state.currentStakeAmount &&
                    this.state.betValuePlayer2 <= 2 * this.state.currentStakeAmount
                ) {
                    this.channel
                        .push("click_bet_blind", {
                            turn: this.state.turn,
                            betValue: this.state.betValuePlayer2
                        })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            }
        }
    }

    onClickFold() {
        this.channel
            .push("click_fold", { turn: this.state.turn })
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

    onClickShow() {
        if (!this.state.isShow && this.state.listOfUsers.length == 2) {
            this.channel
                .push("change_show", { turn: this.state.turn })
                .receive("ok", resp => {
                    this.got_view(resp);
                });
            if (this.state.turn == 1) {
                if (this.state.isSeenPlayer1) {
                    this.channel
                        .push("evaluate_show_seen", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                } else {
                    this.channel
                        .push("evaluate_show_blind", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            } else {
                if (this.state.isSeenPlayer2) {
                    this.channel
                        .push("evaluate_show_seen", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                } else {
                    this.channel
                        .push("evaluate_show_blind", { turn: this.state.turn })
                        .receive("ok", resp => {
                            this.got_view(resp);
                        });
                }
            }
        }
    }

    render() {
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

        return (
            <div className="mainboard">
                <div className="userList">

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
                    <p>Following users joined successfully: {message}</p>
                </div>

                <Table
                    listOfUsers={this.state.listOfUsers}
                    handForPlayer1={this.state.handForPlayer1}
                    handForPlayer2={this.state.handForPlayer2}
                    state={this.state}
                    channel={this.channel}
                />

                <div className="board">
                    <div class="start">
                        <button className="start" onClick={() => this.startGame()}>
                            Start Game
            </button>
                        <br />
                    </div>
                    <div className="player1">
                        <p>Name: {player1Name}</p>
                        <p>Money: {this.state.moneyPlayer1}</p>
                        <button className="hand1">{this.handValue(0, 1)}</button>
                        <button className="hand2">{this.handValue(1, 1)}</button>
                        <button className="hand3">{this.handValue(2, 1)}</button>
                        <button className="money">Amount: {this.state.moneyPlayer1}</button>
                        <button className="fold" onClick={() => this.onClickFold()}>
                            Fold
            </button>
                        <button className="seen" onClick={() => this.onClickSeen()}>
                            Play Seen
            </button>
                        <br />
                        <input
                            id="tb2"
                            type="text"
                            value={this.state.betValuePlayer1}
                            onChange={e => this.handleBetForPlayer1(e.target.value)}
                        />
                        <br />
                        <button className="bet" onClick={() => this.onClickBet()}>
                            Bet
            </button>
                        <br />
                        <p>{this.state.message1}</p>
                    </div>
                    <hr />
                    <div className="player2">
                        <p>Name: {player2Name}</p>
                        <p>Money: {this.state.moneyPlayer2}</p>
                        <button className="hand1">{this.handValue(0, 2)}</button>
                        <button className="hand2">{this.handValue(1, 2)}</button>
                        <button className="hand3">{this.handValue(2, 2)}</button>
                        <button className="money">Amount: {this.state.moneyPlayer2}</button>
                        <button className="fold" onClick={() => this.onClickFold()}>
                            Fold
            </button>
                        <button className="seen" onClick={() => this.onClickSeen()}>
                            Play Seen
            </button>
                        <input
                            id="tb3"
                            type="text"
                            value={this.state.betValuePlayer2}
                            onChange={e => this.handleBetForPlayer2(e.target.value)}
                        />
                        <br />
                        <button className="bet" onClick={() => this.onClickBet()}>
                            Bet
            </button>
                        <p>{this.state.message2}</p>
                    </div>
                    <div className="show">
                        <button className="show" onClick={() => this.onClickShow()}>
                            Show
            </button>
                        <br />
                    </div>
                    <div className="potAmount">
                        <p>Pot Amount: {this.state.potMoney}</p>
                    </div>
                    <div className="currentStakeAmount">
                        <p>Current Stake Amount: {this.state.currentStakeAmount}</p>
                    </div>
                </div>
            </div>
        );
    }
}

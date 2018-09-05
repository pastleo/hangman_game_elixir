// for phoenix_html support, including form and button helpers
// copy the following scripts into your javascript bundle:
// * https://raw.githubusercontent.com/phoenixframework/phoenix_html/v2.10.0/priv/static/phoenix_html.js

import { Socket } from 'https://unpkg.com/phoenix@1.3.4/assets/js/phoenix.js?module';
//import hyper from 'https://unpkg.com/hyperhtml@2.13.2/esm/index.js?module';
import HyperHTMLElement from 'https://unpkg.com/hyperhtml-element@3.0.0/esm/index.js?module';
const { hyper } = HyperHTMLElement;

// socket
const socket = new Socket("/socket", {})
socket.connect()
const channel = socket.channel("hangman:game", {})

// Tally
class Tally extends HyperHTMLElement {
  get defaultState() {
    return {
      state: 'init',
      letters: [],
      left_turns: 0,
      used: [],
    };
  }

  render() {
    return this.html`
      <h2>${this.stateToMsg(this.state.state)}</h2>
      <p>Letters: ${this.letters(this.state.letters)}</p>
      <p>Left: ${this.state.left_turns}</p>
      <p>You have guessed: ${this.letters(this.state.used)}</p>
    `;
  }

  setTally({ state, letters, left_turns, used }) {
    this.setState({ state, letters, left_turns, used });
  }

  letters(l) {
    return l.join(' ');
  }
  stateToMsg(state) {
    return {
      init: "New game started",
      lose: "You lose...",
      won: "You won!",
      good_guess: "Good guess",
      bad_guess: "Bad guess",
      already_used: "Already used",
      guess_isnt_valid: "Not valid input",
    }[state];
  }
}
Tally.define('hangman-tally');

// channel
channel
  .on("tally", tally => {
    document.getElementById('tally').setTally(tally);
  })
channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
    channel.push("tally", {})
  })
  .receive("error", resp => {
    alert("Unable to join", resp)
    throw(resp)
  })

// Interact
hyper(document.getElementById('root'))`
  <div style='margin: 20px;'>
    <hangman-tally id='tally' />
    <input type='text' style='width: 250px;' placeholder='enter an alphabet and press enter here' onkeypress='${({target, which}) => {
      if(which === 13) {
        channel.push("move", target.value);
        target.value = '';
      }
    }}' />
    <br />
    <button onclick=${() => { channel.push('new'); }}>New Game</button>
  </div>
`


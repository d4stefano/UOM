// Import the page's CSS. Webpack will know what to do with it.
import '../styles/app.css'

// Import libraries we need.
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import mastermindArtifact from '../../build/contracts/Mastermind.json'

// Mastermind is our usable abstraction, which we'll use through the code below.
const Mastermind = contract(mastermindArtifact)

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
let accounts
let account

const App = {
	
	
	attemptBreak: function(){
		const self = this;
		
		let meta
		Mastermind.deployed().then(function (instance) {
      meta = instance
	  
	  var val1 = document.getElementById('val1').value;
	  var val2 = document.getElementById('val2').value;
	  var val3 = document.getElementById('val3').value;
	  var val4 = document.getElementById('val4').value;
	  
	  var attempt= [];
	  attempt.push(val1);
	  attempt.push(val2);
	  attempt.push(val3);
	  attempt.push(val4);
	  
      return meta.attemptBreak(attempt, { from: accounts[0], value: 1, gas:1400000 })
    }).then(function () {
      return  meta.getLastResultAttempts.call({from:account});
   
    }).then(function(result){
		alert(result);
	}).catch(function (e) {
      console.log(e)
      //self.setStatus('Error getting balance; see log.')
    })
		
	},
  start: function () {
    const self = this

    // Bootstrap the Mastermind abstraction for Use.
    Mastermind.setProvider(web3.currentProvider)

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function (err, accs) {
      if (err != null) {
        alert('There was an error fetching your accounts.')
        return
      }

      if (accs.length === 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.")
        return
      }

      accounts = accs
      account = accounts[0]

	  document.getElementById('codeMaker').innerHTML = accs[0];
	  document.getElementById('codeBreaker').innerHTML = accs[1];
	  
	  let meta
		Mastermind.deployed().then(function (instance) {
      meta = instance
	  
	           var myEvent = instance.comparing({},{fromBlock: 0, toBlock: 'latest'});
        myEvent.watch(function(error, result){
            console.log("on watch");
            console.log(result);
            console.log(result.args);
        })
		});
		
    })
  }
}

window.App = App

window.addEventListener('load', function () {
  
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:8545'))
  

  
		
  App.start()
})

var Mastermind = artifacts.require('./Mastermind.sol')

module.exports = function (deployer) {
  deployer.deploy(Mastermind,[1,2,3,4], web3.eth.accounts[1], {from:web3.eth.accounts[0], value:13});
}

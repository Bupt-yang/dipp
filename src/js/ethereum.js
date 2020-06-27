app = {
    web3: null,
    web3Provider: null,
    donationContract: null,
    donationInstance: null,
    initWeb3() {
        var Web3 = require('web3');
        if (typeof web3 !== 'undefined') {
            this.web3Provider = web3.currentProvider;
            this.web3 = new Web3(this.web3Provider);
        } else {
            this.web3Provider = new Web3.providers.HttpProvider("http://localhost:7545");
            this.web3 = new Web3(this.web3Provider);
        }
    },
    async  initContract() {
        var contract = require("@truffle/contract");
        var donationArtifact = require("../../build/contracts/Donation.json");
        this.donationContract = contract(donationArtifact);
        this.donationContract.setProvider(this.web3Provider);
        this.donationInstance = await this.donationContract.deployed();
        //console.log(this.donationInstance);
    }
}
module.exports = app;

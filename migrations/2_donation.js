const donation = artifacts.require("Donation");

module.exports = function(deployer) {
  deployer.deploy(donation);
};

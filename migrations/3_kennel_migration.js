var KennelPedigrees = artifacts.require("./KennelPedigrees.sol");

module.exports = function(deployer) {
  deployer.deploy(KennelPedigrees);
};

var AssetTracker = artifacts.require("./SupplyChain.sol");

module.exports = function(deployer) {
  deployer.deploy(AssetTracker);
};

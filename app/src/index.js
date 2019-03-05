import Web3 from "web3";
import supplyChainArtifact from "../../build/contracts/SupplyChain.json";

const App = {
  web3: null,
  account: null,
  meta: null,

  start: async function() {
    const { web3 } = this;

    try {
      // get contract instance
      const networkId = await web3.eth.net.getId();
      console.log("networkId"+networkId)
      const deployedNetwork = supplyChainArtifact.networks[networkId];
      this.meta = new web3.eth.Contract(
        supplyChainArtifact.abi,
        deployedNetwork.address,
      );

      // get accounts
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];

      console.log(accounts[0] + "  " + deployedNetwork.address);

      this.refreshBalance();
    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
  },

  refreshBalance: async function() {
    console.log("start referesh");
    const { getBalance } = this.meta.methods;
    const balance = await getBalance(this.account).call();
    console.log("start referesh1" + balance);
    const balanceElement = document.getElementsByClassName("balance")[0];
    balanceElement.innerHTML = balance;
  },

  sendCoin: async function() {
    console.log("start send coin")
    console.log("start send 2")
    const name = document.getElementById("name").value;
    console.log("start name "+ name)
    const description = document.getElementById("description").value;
    console.log("start Description "+ description)
    const product_id = document.getElementById("product_id").value;
    console.log("start product_id "+ product_id)
    const manufacturer = document.getElementById("manufacturer").value;
    console.log("start manufacturer "+ manufacturer)
    const { createAsset } = this.meta.methods;
    console.log(createAsset)
    console.log("create asset before" + this.account)
    await createAsset(name, description,product_id,manufacturer ).send({ from: this.account });
    console.log("create asset after")
    //this.setStatus("Transaction complete!");
    this.refreshBalance();
  },

  getAsset: async function() {
    const { getAssetByUUID } = this.meta.methods;
    console.log(getAssetByUUID)
    const productid = document.getElementById("productid").value;
    console.log(":::::::::::::"+productid)
    //await getAssetByUUID(productid).send({ from: this.account });
    await getAssetByUUID(productid).call;
  },

  setStatus: function(message) {
    const status = document.getElementById("status");
    status.innerHTML = message;
  },
};

window.App = App;

window.addEventListener("load", function() {
  if (window.ethereum) {
    // use MetaMask's provider
    console.log("Metaaaaaaaa maskkkkkk")
    App.web3 = new Web3(window.ethereum);
    window.ethereum.enable(); // get permission to access accounts
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live",
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    App.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:8545"),
    );
  }

  App.start();
});

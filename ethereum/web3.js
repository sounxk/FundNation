import Web3 from "web3";

let web3;

if (typeof window !== "undefined" && typeof window.web3 !== "undefined") {
  // We are on the browser and metamask is running
  web3 = new Web3(window.web3.currentProvider);
} else {
  // We are in the server or user is not running metamask
  const provider = new Web3.providers.HttpProvider(
    "https://rinkeby.infura.io/v3/54f6b552a70d4f9cbb87dfb93b6647f2"
  );
  web3 = new Web3(provider);
}

export default web3;

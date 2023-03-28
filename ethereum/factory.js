import web3 from "./web3";
import CampignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
  JSON.parse(CampignFactory.interface),
  "0x01b5077cD4829d52E957Ed02cA5c8CeF655aa918"
);

export default instance;

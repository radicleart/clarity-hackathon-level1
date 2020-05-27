import { Client, Provider, ProviderRegistry, Result } from "@blockstack/clarity";
import { assert } from "chai";
import { readFromContract, execMethod } from "./query-utils"
import * as fs from "fs";
import {
  makeSmartContractDeploy,
  makeContractCall,
  TransactionVersion,
  FungibleConditionCode,
  uintCV,
  ChainID,
  makeStandardSTXPostCondition,
  makeContractSTXPostCondition,
  StacksTestnet,
  broadcastTransaction,
} from "@blockstack/stacks-transactions";
const BigNum = require("bn.js"); 
const STACKS_API_URL = "http://localhost:20443";
describe("collectibles tutorial test suite", () => {
  // const contractSig = "ST2ZRX0K27GW0SP3GJCEMHD95TQGJMKB7G9Y0X1MH";
  const owner1Sig = "ST18PE05NG1YN7X6VX9SN40NZYP7B6NQY6C96ZFRC";
  const owner2Sig = "STFJEDEQB1Y1CQ7F04CS62DCS5MXZVSNXXN413ZG";

  //before(async () => {
    // provider = await ProviderRegistry.createProvider();
    // client = new Client(contractSig + ".collectibles", "collectibles", provider);
  //});

  describe("Deploying an instance of the contract", () => {
    it("should mint a non fungible token", async () => {
      const contractKeys = JSON.parse(fs.readFileSync("./keys-contract.json").toString());
      const minterKeys = JSON.parse(fs.readFileSync("./keys-minter.json").toString());
  
      const contractName = "collectibles";
      const codeBody = fs
        .readFileSync("./contracts/collectibles.clar")
        .toString();
  
      const price = 0x1000;
  
      var fee = new BigNum(2548);
      const network = new StacksTestnet();
      network.coreApiUrl = STACKS_API_URL;
  
      console.log("deploy contract");
      var transaction = await makeSmartContractDeploy({
        contractName,
        codeBody,
        fee,
        senderKey: contractKeys.secretKey,
        nonce: new BigNum(0),   // watch for nonce increments if this works - may need to restart mocknet!
        network,
      });
      console.log(transaction);
      console.log(await broadcastTransaction(transaction, network));

      await new Promise((r) => setTimeout(r, 30000));
      console.log("dc-mint: ");
      fee = new BigNum(256);

      transaction = await makeContractCall({
        contractAddress: contractKeys.stacksAddress,
        contractName,
        functionName: "dc-mint",
        functionArgs: [uintCV(price)],
        fee,
        senderKey: minterKeys.secretKey,
        nonce: new BigNum(0),
        network,
      });
      console.log(transaction);
      console.log(await broadcastTransaction(transaction, network));
       /** 
        **/
      });
  });
/**

  describe("NFT Tests", () => {
    it("should allow new token to be minted", async () => {
      let txreceive = await execMethod(client, owner1Sig, "dc-mint", [`'${owner2Sig}`, "u500"]);
      assert.isOk(txreceive.success);
      const result = await readFromContract(client, "dc-get", ["\"asset1\""]);
      assert.equal(result.rawResult, "(ok ())");
    })
  });
 * 
 */
  after(async () => {
    // await provider.close();
  });
});

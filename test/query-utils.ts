import {
    Client,
    Result,
    Receipt,
} from "@blockstack/clarity";

interface NameValuePair { name: string; value: string; }

function unwrapStrings(tuple: string): [string]|RegExpMatchArray {
  var names = tuple.match(/0x\w+/g) || [];
  for(let i=0; i<names.length; i++){
    names[i] = Buffer.from(names[i].substring(2), "hex").toString();
  }
  console.log("\tReturned from contract: tuple=" + tuple + " resolved strings: ", names)
  return names;
}

async function performQuery(client: Client, name: string, args: string[]): Promise<Object> {
    const query = client.createQuery({
        method: { name, args },
    });
    const receipt = await client.submitQuery(query);
    const result = Result.unwrap(receipt);
    return {rawResult: result, strings: unwrapStrings(result)};
}

async function readFromContract(client: Client, method: string, args: string[]): Promise<any> {
    return await performQuery(client, method, args);
};

async function execMethod(client: Client, signature: string, method: string, args: string[]): Promise<Receipt> {
    const tx = client.createTransaction({
        method: {
            name: method,
            args: args,
        },
    });
    await tx.sign(signature);
    const receipt = await client.submitTransaction(tx);
    console.log(receipt);
    return receipt;
};

export {readFromContract, execMethod}

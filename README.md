# Clarity Hackathon Level 0 2020

## Minting Non Fungible Digital Collectibles

This contract allows non fungible tokens to be minted in exchange for a small quantity of STX.
The specific amount of STX required to mint is project dependent and set by the project initiator.
The contract is inspired by the Open Sea platform and our work building radicleart and loopbomb
apps on Blockstack tech.
The main goals here are;

* minting of digital collectibles
* cost of minting is configurable per project

This contract connects with ongoing d-app  where project meta data and collectibles and other digital assets
are stored decentrally using Gaia hubs. For this purpose digital collectibles is considered to be a space of SHA 256 hashes
which secure the collectible itself and or its provenance (ownership history) data.

## Unit Testing

```bash
git clone git@github.com:radicleart/clarity-hackathon-level0.git

npm install
```

Tested with node version `nvm use v12.16.3`

## Integration Testing

Testing of this contract requires integration testing on the stacks mocknet. A high level description is presented below
but most of the details were worked out by  [Friedger](https://github.com/friedger/clarity-smart-contracts) in Blockstack Community
so please head over there and check out his `escrow` contract for full details.

Generate two key sets using

```bash
cargo run --bin blockstack-cli generate-sk --testnet
```

Edit Stacks.toml to add the public key and set initial balances and run mocknet

```bash
vi $HOME/stacks-blockchain/testnet/stacks-node/Stacks.toml

nohup cargo testnet start --config=./testnet/stacks-node/Stacks.toml &

// tail the log file to watch for runtime errors in your script...
tail -f -n 200000 nohup.out | grep -i ST18PE05NG1YN7X6VX9SN40NZYP7B6NQY6C96ZFRC
```

Check balances and contract deployment using the API;

* Minter Balance: http://127.0.0.1:20443/v2/accounts/ST18PE05NG1YN7X6VX9SN40NZYP7B6NQY6C96ZFRC
* Contract Balance: http://127.0.0.1:20443/v2/accounts/STFJEDEQB1Y1CQ7F04CS62DCS5MXZVSNXXN413ZG
* Contract Source: http://127.0.0.1:20443/v2/contracts/source/ST18PE05NG1YN7X6VX9SN40NZYP7B6NQY6C96ZFRC/collectibles

## References

* [Blockstack Clarity Documentation](https://docs.blockstack.org/core/smart/rpc-api.html)
* [Stacks Transactions JS Library](https://github.com/blockstack/stacks-transactions-js)
* [Stacks Blockchain](https://github.com/blockstack/stacks-blockchain)
* [Clarity JS SDK](https://github.com/blockstack/clarity-js-sdk)
* [Clarity VSCode](https://github.com/blockstack/clarity-vscode)
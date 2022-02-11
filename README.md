# Medianite

This repo is for managing the code for Median deploys across multiple chains, such as Ethereum, Arbitrum, Optimism, etc.

It's based on the pattern [described here](https://collateral.makerdao.com/oracles-domain/untitled#8.-prepare-the-medianizer-and-osm-contracts), and uses [makerdao/median](https://github.com/makerdao/median) as the source template.

Effectively, it allows you to generate a Median deploy segregated by *chain* and *pair*. For instance you might need a Median contract deployed on Arbitrum (an L2) for the ETHUSD pair, and a different one for Optimism/ETHUSD, and yet another one for Arbitrum/AAVEUSD.

## Getting started

Each deployed contract will be stored under the `deploy` folder based on the chain and pair. For example

```
deploy/arbitrum-ETHUSD
```

will contain the Median source code that is deployed to Arbitrum for the ETHUSD pair. This code should be the same whether running a local testnet, the chain's testnet (e.g. Rinkeby), or the chain's mainnet.

### Prerequisites

You'll need [dapptools](https://dapp.tools/) along with a pretty normal selection of dev tools like `make`, `git`, `jq`, and `bash`.


### Create a new deploy

Simply run

```
make new-deploy
```

and you will be prompted for a couple pieces of information. A deploy folder will be created and the source generated. After running the above, you can `cd` into the deploy folder and do the usual things, e.g.

```
cd deploy/arbitrum-ETHUSD
make build
make test
```

### Secrets

For testing various Ethereum accounts have been created. They live in this repository, and are encrypted by [sops](https://github.com/mozilla/sops).

The script `ethaccounts.sh` can be used to decrypt and store these accounts locally in the `.testing_keytsore` folder, and they can be used for running integration tests via `test.sh`.

You will need to have access to the master (gpg) key. It is also encrypted and stored in the repo. It can be shared over secure channels. Once imported, you should be able to encrypt or decrypt any secret file stored anywhere in this repo.





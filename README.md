# Place

Ethereum DApp implementation of reddit's place.

## Status

Currently, the solidity contract is publicly available, with the web interface in progress.


### Prerequisites

In order to compile and deploy the contracts, truffle must installed.

For the most up to date installation: https://github.com/trufflesuite/truffle

### Compiling and Deploying

Refer to truffle documentation for prerequisites to compile and deploy the contract.

First, run Truffle's blockchain server seperately

```
ganache-cli
```

Then compile and migrate

```
truffle compile
truffle migrate
```

The contract is now deployed to the local blockchain server and may be interacted with using

```
truffle console
```


## Built With
* [Truffle](https://github.com/trufflesuite/truffle) - Development environment and testing framework

## Authors

* **Brandon Nieves** - *Initial work* - [mellamoBrandon](https://github.com/mellamoBrandon)


## Acknowledgments

* Thanks to the reddit engineering team for their article on their thought process: https://redditblog.com/2017/04/13/how-we-built-rplace/

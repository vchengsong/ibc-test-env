#!/usr/bin/env bash

CONTRACTS_DIR=/Code/github.com/EOSIO/eosio.contracts/build
IBC_CONTRACTS_DIR=/Code/github.com/vchengsong/ibc_contracts/build
WALLET_DIR=/Users/song/tmp/eosio/eosio-wallet

cleos1='cleos -u http://127.0.0.1:8888'
cleos2='cleos -u http://127.0.0.1:8889'

contract_chain=ibc2chain555
contract_chain_folder=ibc.chain

contract_token=ibc2token555
contract_token_folder=ibc.token

token_c_pubkey=EOS6Sc4BuA7dEGRU6u4VSuEKusESFe61qD8LmguGEMULrghKDSPaU
token_c_prikey=5K79wAY8rgPwWQSRmyQa2BR8vPicieJdLCXL3cM5Db77QnsJess

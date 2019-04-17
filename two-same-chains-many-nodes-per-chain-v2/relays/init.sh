#!/usr/bin/env bash

. ./../env.sh

        nodeos=${repo_dir}/build/programs/nodeos/nodeos
eosio_launcher=${repo_dir}/build/programs/eosio-launcher/eosio-launcher
         cleos=${repo_dir}/build/programs/cleos/cleos

program_dir=./programs
if [ -d ${program_dir} ]; then
    rm -rf ${program_dir}
fi

mkdir -p ${program_dir}/nodeos
cp ${nodeos} ${program_dir}/nodeos/

cleos1='cleos -u http://127.0.0.1:8888'
cleos2='cleos -u http://127.0.0.1:8889'

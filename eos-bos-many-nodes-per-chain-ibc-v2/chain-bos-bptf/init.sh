#!/usr/bin/env bash

base_dir=/Code/github.com

nodeos_repo_dir=${base_dir}/eosiosg/eos
#nodeos_repo_dir=${base_dir}/EOSIO/eos

build=build

nodeos=${nodeos_repo_dir}/${build}/programs/nodeos/nodeos
eosio_launcher=${nodeos_repo_dir}/${build}/programs/eosio-launcher/eosio-launcher
cleos=${nodeos_repo_dir}/${build}/programs/cleos/cleos

now=`date -u +%Y-%m-%dT%H:%M:%S.000`

program_dir=./programs
if [ -d ${program_dir} ]; then
    rm -rf ${program_dir}
fi

mkdir -p ${program_dir}/nodeos
cp ${nodeos} ${program_dir}/nodeos/






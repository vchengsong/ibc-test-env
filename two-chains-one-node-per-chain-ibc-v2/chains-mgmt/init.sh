#!/usr/bin/env bash

program_dir=./programs
if [ -d ${program_dir} ]; then
    rm -rf ${program_dir}
fi

mkdir -p ${program_dir}/nodeos/eos
mkdir -p ${program_dir}/nodeos/bos

cp /Code/github.com/vonhenry/eos/build/programs/nodeos/nodeos ${program_dir}/nodeos/eos
cp /Code/github.com/vonhenry/eos/build/programs/nodeos/nodeos ${program_dir}/nodeos/bos


#cp /Code/github.com/EOSIO/eos/build/programs/nodeos/nodeos   ${program_dir}/nodeos/eos
#cp /Code/github.com/eosiosg/eos/build/programs/nodeos/nodeos ${program_dir}/nodeos/bos

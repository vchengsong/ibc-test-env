#!/usr/bin/env bash

. ./../env.sh

        nodeos=${repo_dir}/build/programs/nodeos/nodeos
eosio_launcher=${repo_dir}/build/programs/eosio-launcher/eosio-launcher
         cleos=${repo_dir}/build/programs/cleos/cleos

now=`date -u +%Y-%m-%dT%H:%M:%S.000`

program_dir=./programs
if [ -d ${program_dir} ]; then
    rm -rf ${program_dir}
fi

mkdir -p ${program_dir}/nodeos
cp ${nodeos} ${program_dir}/nodeos/






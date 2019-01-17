#!/usr/bin/env bash

base_dir=/Code/github.com
relative_dir=/build/programs/nodeos/nodeos

now=`date -u +%Y-%m-%dT%H:%M:%S.000`

program_dir=./programs
if [ -d ${program_dir} ]; then
    rm -rf ${program_dir}
fi

mkdir -p ${program_dir}/nodeos-eos
cp ${base_dir}/boscore/ibc_plugin_eos/${relative_dir} ${program_dir}/nodeos-eos/

mkdir -p ${program_dir}/nodeos-bos
cp ${base_dir}/boscore/ibc_plugin_bos/${relative_dir} ${program_dir}/nodeos-bos/


cleos1='cleos -u http://127.0.0.1:8888'
cleos2='cleos -u http://127.0.0.1:8889'


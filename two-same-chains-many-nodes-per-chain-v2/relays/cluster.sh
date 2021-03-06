#!/bin/bash

. init.sh
. config.sh

cluster_init(){
    cluster_clear

    cName=config.ini
    lName=logging.json
    gName=genesis.json

    for i in 1 2; do
        path=staging/etc/eosio/node${i}
        mkdir -p $path
        r=confignode$i && echo "${!r}"  > $path/$cName
        echo "$config_common" >>  $path/$cName
        echo "$logging_v"     > $path/$lName
    done

    cp ../chain-first/staging/etc/eosio/node_00/genesis.json   staging/etc/eosio/node1/genesis.json
    cp ../chain-second/staging/etc/eosio/node_00/genesis.json  staging/etc/eosio/node2/genesis.json
}

cluster_start(){
    echo "starting node 1"
   ./programs/nodeos/nodeos -d var/lib/node1/ --config-dir staging/etc/eosio/node1 --genesis-json staging/etc/eosio/node1/genesis.json
#   ./programs/nodeos/nodeos -d var/lib/node1/ --config-dir staging/etc/eosio/node1

    echo "starting node 2"
   ./programs/nodeos/nodeos -d var/lib/node2/ --config-dir staging/etc/eosio/node2 --genesis-json staging/etc/eosio/node2/genesis.json
#   ./programs/nodeos/nodeos -d var/lib/node2/ --config-dir staging/etc/eosio/node2
}

cluster_clear(){
    rm *.json *.dot *.ini *.log topology* 2>/dev/null
    rm -rf staging
    rm -rf etc/eosio/node_*
    rm -rf var/lib

    cd ./../ibc-test/ && ./clear.sh 2>/dev/null && cd - >/dev/null

    pids=`ps -ef | grep ./programs/nodeos/nodeos | cut -d' ' -f 4 | head -n 2`

    for p in $pids; do
        kill -9 $p
    done
}


if [ "$#" -ne 1 ];then
	echo "usage: cluster.sh init|start-gen|start|clear"
	exit 0
fi

case "$1"
in
    "init"  )       cluster_init;;
    "start" )       cluster_start;;
    "clear" )       cluster_clear;;
    *) echo "usage: cluster.sh init|start|clear" ;;
esac


#!/bin/bash

. init.sh
. config.sh

cluster_init(){
    cluster_clear

    cName=config.ini
    lName=logging.json
    gName=genesis.json

    for i in 1 2 3; do
        path=staging/etc/eosio/node${i}
        mkdir -p $path
        r=config_eos_node${i} && echo "${!r}"  > $path/$cName
        echo "$config_common" >>  $path/$cName
        echo "$logging_v"     >   $path/$lName

        cp ../chain-eos/staging/etc/eosio/node_00/genesis.json   staging/etc/eosio/node${i}/genesis.json
    done

    for i in 1 2 3; do
        path=staging/etc/boscore/node${i}
        mkdir -p $path
        r=config_bos_node${i} && echo "${!r}"  > $path/$cName
        echo "$config_common" >>  $path/$cName
        echo "$logging_v"     >   $path/$lName

        cp ../chain-bos/staging/etc/eosio/node_00/genesis.json   staging/etc/boscore/node${i}/genesis.json
    done
}


eos_relays_start(){
    echo "starting node 1"
    node1data=var/lib/node1/
    node1conf=staging/etc/eosio/node1
    genesis=staging/etc/eosio/node1/genesis.json

    gen=""
    if [ "$1" == "gen" ];then
        gen="--genesis-json $genesis"
    fi
    nohup ./programs/nodeos-eos/nodeos -d $node1data --config-dir $node1conf  $gen > node1.log &

#   ./programs/nodeos-eos/nodeos -d var/lib/eosio/node1/ --config-dir staging/etc/eosio/node1 --genesis-json staging/etc/eosio/node1/genesis.json
#   ./programs/nodeos-eos/nodeos -d var/lib/eosio/node1/ --config-dir staging/etc/eosio/node1


#   ./programs/nodeos-eos/nodeos -d var/lib/eosio/node2/ --config-dir staging/etc/eosio/node2 --genesis-json staging/etc/eosio/node2/genesis.json
#   ./programs/nodeos-eos/nodeos -d var/lib/eosio/node2/ --config-dir staging/etc/eosio/node2


#   ./programs/nodeos-eos/nodeos -d var/lib/eosio/node3/ --config-dir staging/etc/eosio/node3 --genesis-json staging/etc/eosio/node3/genesis.json
#   ./programs/nodeos-eos/nodeos -d var/lib/eosio/node3/ --config-dir staging/etc/eosio/node3

}


bos_relays_start(){
    echo "starting node 2"
    node2data=var/lib/node2/
    node2conf=staging/etc/eosio/node2
    genesis=staging/etc/eosio/node2/genesis.json

    gen=""
    if [ "$1" == "gen" ];then
        gen="--genesis-json $genesis"
    fi
    nohup ./programs/nodeos-bos/nodeos -d $node2data --config-dir $node2conf  $gen > node2.log &
#   ./programs/nodeos-bos/nodeos -d var/lib/boscore/node1/ --config-dir staging/etc/boscore/node1 --genesis-json staging/etc/boscore/node1/genesis.json
#   ./programs/nodeos-bos/nodeos -d var/lib/boscore/node1/ --config-dir staging/etc/boscore/node1


#   ./programs/nodeos-bos/nodeos -d var/lib/boscore/node2/ --config-dir staging/etc/boscore/node2 --genesis-json staging/etc/boscore/node2/genesis.json
#   ./programs/nodeos-bos/nodeos -d var/lib/boscore/node2/ --config-dir staging/etc/boscore/node2

#   ./programs/nodeos-bos/nodeos -d var/lib/boscore/node3/ --config-dir staging/etc/boscore/node3 --genesis-json staging/etc/boscore/node3/genesis.json
#   ./programs/nodeos-bos/nodeos -d var/lib/boscore/node3/ --config-dir staging/etc/boscore/node3


}




cluster_clear(){
    rm *.json *.dot *.ini *.log topology* 2>/dev/null
    rm -rf staging
    rm -rf etc/*
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
    "start-gen" )    cluster_start gen;;
    "start" )       cluster_start;;
    "clear" )       cluster_clear;;
    *) echo "usage: cluster.sh init|start-gen|start|clear" ;;
esac



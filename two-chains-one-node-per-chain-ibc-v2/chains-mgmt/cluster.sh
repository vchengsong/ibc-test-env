#!/bin/bash

. init.sh
#. config_no_ibc.sh
. config.sh

cluster_init(){
    cluster_clear

    cName=config.ini
    lName=logging.json
    gName=genesis.json

    for i in 1 2; do
        path=staging/etc/eosio/node_bios${i}
        mkdir -p $path
        r=configbios$i && echo "${!r}"  > $path/$cName
        echo "$config_common" >>  $path/$cName
        echo "$logging_v"     > $path/$lName
        echo "$genesis"     > $path/$gName
    done
}


cluster_start(){
    node1data=var/lib/node_bios1/
    node1conf=staging/etc/eosio/node_bios1
    ./programs/nodeos/eos/nodeos -e -p eosio -d $node1data --config-dir $node1conf  \
        --plugin eosio::chain_api_plugin --plugin eosio::producer_plugin  \
        --plugin eosio::producer_api_plugin --plugin eosio::history_api_plugin  \
        --contracts-console  --max-transaction-time 1000


    node2data=var/lib/node_bios2/
    node2conf=staging/etc/eosio/node_bios2
    ./programs/nodeos/bos/nodeos -e -p eosio -d $node2data --config-dir $node2conf  \
        --plugin eosio::chain_api_plugin --plugin eosio::producer_plugin  \
        --plugin eosio::producer_api_plugin --plugin eosio::history_api_plugin  \
        --contracts-console --max-transaction-time 1000        --plugin eosio::pbft_plugin
}



cluster_clear(){
    killall nodeos 2>/dev/null
    rm *.json *.dot *.ini *.log topology* 2>/dev/null
    rm -rf staging
    rm -rf etc/eosio/node_*
    rm -rf var/lib

    cd ./../ibc-test/ && ./clear.sh 2>/dev/null && cd - >/dev/null
}


if [ "$#" -ne 1 ];then
	echo "usage: cluster.sh init|start|down|bounce|clear"
	exit 0
fi


case "$1"
in
    "init"  )   cluster_init;;
    "start" )   cluster_start;;
    "clear" )   cluster_clear;;
    *) echo "usage: cluster.sh init|start|clear" ;;
esac



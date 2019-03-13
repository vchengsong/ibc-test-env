#!/usr/bin/env bash

. env.sh

IBC_CONTRACTS_DIR=/Code/github.com/boscore/ibc_contracts/build

set_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    echo ---- cluster 1 ----
    ${!cleos} set contract ${contract_chain} ${IBC_CONTRACTS_DIR}/${contract_chain_folder} -x 1000 -p ${contract_chain}
    sleep 1
    echo && echo ---- cluster 2 ----
    ${!cleos} set contract ${contract_token} ${IBC_CONTRACTS_DIR}/${contract_token_folder} -x 1000 -p ${contract_token}
}
set_contracts c1
set_contracts c2


set_random_contracts(){
    $cleos2 set contract ${contract_rand} ../random -x 1000 -p ${contract_rand}
}
set_random_contracts c2



init_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}

    # --- ibc.chain ---
    ${!cleos}  push action  ${contract_chain} setglobal '[{"lib_depth":85}]' -p ${contract_chain}
    ${!cleos}  push action  ${contract_chain} relay '["add","ibc2relay555"]' -p ${contract_chain}
    #cleos get table ${contract_chain} ${contract_chain} global
}
init_contracts c1
init_contracts c2



init_contracts_2(){
    $cleos1 push action ${contract_token} setglobal '["ibc2chain555","bos","ibc2token555",5000,1000,10,true]' -p ${contract_token}
    $cleos2 push action ${contract_token} setglobal '["ibc2chain555","eos","ibc2token555",5000,1000,10,true]' -p ${contract_token}
}

init_contracts_2



init_two(){
    $cleos1 push action ${contract_token} regacpttoken \
        '["eosio.token","1000000000.0000 EOS","ibc2token555","10.0000 EOS","5000.0000 EOS",
        "100000.0000 EOS",1000,"eos organization","www.eos.com","fixed","0.1000 EOS",0.01,"fixed","0.1000 EOS",0.01,true,"4,EOSPG"]' -p ${contract_token}
    $cleos1 push action ${contract_token} regpegtoken \
        '["1000000000.0000 BOSPG","10.0000 BOSPG","5000.0000 BOSPG",
        "100000.0000 BOSPG",1000,"ibc2token555","eosio.token","4,BOS","fixed","0.1000 BOSPG",0.01,true]' -p ${contract_token}


    $cleos2 push action ${contract_token} regacpttoken \
        '["eosio.token","1000000000.0000 BOS","ibc2token555","10.0000 BOS","5000.0000 BOS",
        "100000.0000 BOS",1000,"bos organization","www.bos.com","fixed","0.1000 BOS",0.01,"fixed","0.1000 BOS",0.01,true,"4,BOSPG"]' -p ${contract_token}
    $cleos2 push action ${contract_token} regpegtoken \
        '["1000000000.0000 EOSPG","10.0000 EOSPG","5000.0000 EOSPG",
        "100000.0000 EOSPG",1000,"ibc2token555","eosio.token","4,EOS","fixed","0.1000 EOSPG",0.01,true]' -p ${contract_token}
}
init_two

return

get_chain_table(){
    echo --- cleos1 ---
    $cleos1 get table ${contract_chain} ${contract_chain} $1
    echo && echo --- cleos2 ---
    $cleos2 get table ${contract_chain} ${contract_chain} $1
}

get_token_table(){
    echo --- cleos1 ---
    $cleos1 get table ${contract_token} ${contract_token} $1
    echo && echo --- cleos2 ---
    $cleos2 get table ${contract_token} ${contract_token} $1
}


#    get_chain_table global
#    get_chain_table sections
#    get_chain_table prodsches
#    get_chain_table chaindb

#    get_token_table globals
#    get_token_table globalm
#    get_token_table origtrxs
#    get_token_table cashtrxs

#    get_token_table accepts
#    get_token_table stats


get_chain_table_blkrtmkls(){
    echo --- cleos1 ---
    $cleos1 get table ${contract_chain} ibc2relay555 blkrtmkls
    echo && echo --- cleos2 ---
    $cleos2 get table ${contract_chain} ibc2relay555 blkrtmkls
}

#get_chain_table_blkrtmkls


get_account(){
    echo --- cleos1 ---
    $cleos1 get account  $1
    echo && echo --- cleos2 ---
    $cleos2 get account  $1
}
#    get_account ibc2relay555
#    get_account ibc2token555
#    get_account ibc2chain555

generate_random(){
    $cleos2 push action ibc2random22 generate '[{"loop":1, "num":1}]' -p ibc2random22
}


transfer(){
    $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "chengsong111@bos notes infomation" -p firstaccount
    $cleos2 transfer -f firstaccount ibc2token555 "10.0000 BOS" "chengsong111@eos notes infomation" -p firstaccount
}

withdraw(){
    $cleos1 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 BOSPG" "receiverbos1@bos notes infomation"]' -p chengsong111
    $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "receivereos1@eos notes infomation"]' -p chengsong111
}

transfer_fail(){
    $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "chengsong123@bos" -p firstaccount
    $cleos2 transfer -f firstaccount ibc2token555 "10.0000 BOS" "chengsong123@eos" -p firstaccount
}

withdraw_fail(){
    $cleos1 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 BOSPG" "receiver1111@bos"]' -p chengsong111
    $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "receiver1111@eos"]' -p chengsong111
}


once(){
    for i in `seq 10`; do transfer && sleep .2 ;done
    for i in `seq 10`; do withdraw && sleep .2 ;done
    for i in `seq 2`; do transfer_fail && sleep .2 ;done
    for i in `seq 2`; do transfer_fail && sleep .2 ;done
}

black_acnt_transfer(){
    $cleos1 transfer -f blacklist111 ibc2token555 "10.0000 EOS" "ibc receiver=chengsong111" -p blacklist111
}

black_acnt_transfer
$cleos1 get currency balance eosio.token blacklist111 "EOS"



get_balance(){
    $cleos1 get table ibc2token555 $1 accounts
    $cleos2 get table ibc2token555 $1 accounts
}
#    get_balance chengsong111
#    get_balance chengsong111


get_receiver_b(){
    $cleos1 get currency balance eosio.token receivereos1 "EOS"
    $cleos2 get currency balance eosio.token receiverbos1 "BOS"
}
#    get_receiver_b

pressure(){
    for i in `seq 10000`; do transfer && sleep .5 ;done
    for i in `seq 10000`; do withdraw && sleep .5 ;done
    $cleos1 get table ibc2chain555 ibc2chain555 chaindb -L 9000 |less
}

get_links(){
     pids=`ps -ef | grep ./programs/nodeos/nodeos | cut -d' ' -f 4 | head -n 2`
     for p in $pids; do
        echo --- $p ---
        lsof -p $p |grep TCP | grep 600
     done
}
#    get_links

huge_pressure(){

    for i in `seq 200`; do withdraw  ; done >/dev/null 2>&1  &

}




##   专项测试
# 批量正向






















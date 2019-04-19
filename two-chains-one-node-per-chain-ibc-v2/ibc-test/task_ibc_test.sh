#!/usr/bin/env bash

. env.sh



set_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    ${!cleos} set contract ${contract_chain} ${IBC_CONTRACTS_DIR}/${contract_chain_folder} -x 1000 -p ${contract_chain}
    sleep .2
    ${!cleos} set contract ${contract_token} ${IBC_CONTRACTS_DIR}/${contract_token_folder} -x 1000 -p ${contract_token}
    sleep .2
}
set_contracts c1
set_contracts c2

init_contracts(){
    cleos=cleos1

    lwc_chain_name=bos
    lwc_chain_id=bee381c945baa3bca8dc9bd32f4f888b80f90db118de1f2cd2c6c64ae56381c6
    lwc_consensus=pipeline #batch

    this_chain_name=eos
    peerchain_name=bos
    peerchain_info=bos-mainnt

    if [ "$1" == "c2" ];then
    cleos=cleos2
    lwc_chain_name=eos
    lwc_chain_id=bee381c945baa3bca8dc9bd32f4f888b80f90db118de1f2cd2c6c64ae56381c6
    lwc_consensus=pipeline

    this_chain_name=bos
    peerchain_name=eos
    peerchain_info=eos-mainnt
    fi

    ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${token_c_pubkey}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}

    # --- ibc.chain ---
    ${!cleos}  push action  ${contract_chain} setglobal "[$lwc_chain_name,$lwc_chain_id,$lwc_consensus]" -p ${contract_chain}
    # cleos get table ${contract_chain} ${contract_chain} global

    # --- ibc.token ---
    ${!cleos} push action ${contract_token} setglobal '['$this_chain_name',true]' -p ${contract_token}
    ${!cleos} push action ${contract_token} regpeerchain '['$peerchain_name','$peerchain_info',"ibc2token555","ibc2chain555",5,1000,1000,true]' -p ${contract_token}
    # cleos get table ${contract_token} ${contract_token} globals
    # cleos get table ${contract_token} ${contract_token} peerchains
}
init_contracts c1
init_contracts c2

init_two(){
    $cleos1 push action ${contract_token} regacpttoken \
        '["eosio.token","4,EOS","4,EOSPG","1000000000.0000 EOS","10.0000 EOS","5000.0000 EOS",
        "100000.0000 EOS",1000,"eos organization","https://eos.io","ibc2token555","fixed","0.1000 EOS",0.01,"fixed","0.1000 EOS",0.01,true]' -p ${contract_token}
    # $cleos1 get table ${contract_token} ${contract_token} accepts
    $cleos1 push action ${contract_token} regpegtoken \
        '["bos","eosio.token","4,BOS","4,BOSPG","1000000000.0000 BOSPG","10.0000 BOSPG","5000.0000 BOSPG",
        "100000.0000 BOSPG",1000,"ibc2token555","fixed","0.1000 BOSPG",0.01,true]' -p ${contract_token}
    # $cleos1 get table ${contract_token} ${contract_token} stats

    $cleos2 push action ${contract_token} regacpttoken \
        '["eosio.token","4,BOS","4,BOSPG","1000000000.0000 BOS","10.0000 BOS","5000.0000 BOS",
        "100000.0000 BOS",1000,"bos organization","https://boscore.io","ibc2token555","fixed","0.1000 BOS",0.01,"fixed","0.1000 BOS",0.01,true]' -p ${contract_token}
    # $cleos2 get table ${contract_token} ${contract_token} accepts
    $cleos2 push action ${contract_token} regpegtoken \
        '["eos","eosio.token","4,EOS","4,EOSPG","1000000000.0000 EOSPG","10.0000 EOSPG","5000.0000 EOSPG",
        "100000.0000 EOSPG",1000,"ibc2token555","fixed","0.1000 EOSPG",0.01,true]' -p ${contract_token}
    # $cleos2 get table ${contract_token} ${contract_token} stats
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

#    get_chain_table sections
#    get_chain_table prodsches
#    get_chain_table chaindb
#    get_token_table globals
#    get_token_table globalm
#    get_token_table origtrxs
#    get_token_table cashtrxs


get_account(){
    echo --- cleos1 ---
    $cleos1 get account  $1
    echo && echo --- cleos2 ---
    $cleos2 get account  $1
}
get_account ibc2relay555
get_account ibc2token555
get_account ibc2chain555



transfer(){
    $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "chengsong111@bos notes infomation" -p firstaccount
    $cleos2 transfer -f firstaccount ibc2token555 "10.0000 BOS" "chengsong111@eos notes infomation" -p firstaccount
}

# for i in `seq 10000`; do transfer && sleep 1 ;done


oneway(){
    $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "chengsong111@bos notes infomation" -p firstaccount
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




# for i in `seq 10000`; do transfer && withdraw &&          sleep .5 ;done





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
get_receiver_b

pressure(){
    for i in `seq 10000`; do transfer && sleep .5 ;done
    for i in `seq 10000`; do withdraw && sleep .5 ;done

     $cleos1 get table ibc2chain555 ibc2chain555 chaindb -L 9000 |less





}

huge_pressure(){

    for i in `seq 200`; do withdraw  ; done >/dev/null 2>&1  &

}


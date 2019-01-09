#!/usr/bin/env bash

. env.sh
#. chains_init.sh


set_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi
    ${!cleos} set contract ${contract_chain} ${CONTRACTS_DIR}/${contract_chain_folder} -x 1000 -p ${contract_chain}
    sleep .2
    ${!cleos} set contract ${contract_token} ${CONTRACTS_DIR}/${contract_token_folder} -x 1000 -p ${contract_token}
    sleep .2
}
set_contracts c1
set_contracts c2

init_contracts(){
    cleos=cleos1 && if [ "$1" == "c2" ];then cleos=cleos2 ;fi

    ${!cleos} set account permission ${contract_token} active '{"threshold": 1, "keys":[{"key":"'${pub_key}'", "weight":1}], "accounts":[{"permission":{"actor":"'${contract_token}'","permission":"eosio.code"},"weight":1}], "waits":[] }' owner -p ${contract_token}

    # --- ibc.chain ---
    ${!cleos}  push action  ${contract_chain} setglobal '[{"lib_depth":170}]' -p ${contract_chain}
    ${!cleos}  push action  ${contract_chain} relay '["add","ibc2relay555"]' -p ${contract_chain}
    #cleos get table ${contract_chain} ${contract_chain} global

    # --- ibc.token ---
    ${!cleos} push action ${contract_token} setglobal '["ibc2chain555","ibc2token555",5000,1000,10,true]' -p ${contract_token}

#    ${!cleos} push action ${contract_token} regacpttoken \
#    '["eosio.token","1000000000.0000 EOS","ibc2token555","1.0000 EOS","100.0000 EOS",
#    "1000.0000 EOS",100,"org","websit","fixed","0.0100 EOS",0.01,true,"4,EOS"]' -p ${contract_token}
#
#
#    ${!cleos} push action ${contract_token} regpegtoken \
#    '["1000000000.0000 EOS","1.0000 EOS","100.0000 EOS","1000.0000 EOS",100,
#    "ibc2token555","eosio.token","4,EOS",true]' -p ${contract_token}

    #cleos get table ${contract_token} ${contract_token} globals



}
init_contracts c1
init_contracts c2

init_two(){
    $cleos1 push action ${contract_token} regacpttoken \
        '["eosio.token","1000000000.0000 EOS","ibc2token555","10.0000 EOS","5000.0000 EOS",
        "100000.0000 EOS",1000,"eos organization","www.eos.com","fixed","0.1000 EOS",0.01,true,"4,EOSPG"]' -p ${contract_token}
    $cleos1 push action ${contract_token} regpegtoken \
        '["1000000000.0000 BOSPG","10.0000 BOSPG","5000.0000 BOSPG",
        "100000.0000 BOSPG",1000,"ibc2token555","eosio.token","4,BOS",true]' -p ${contract_token}


    $cleos2 push action ${contract_token} regacpttoken \
        '["eosio.token","1000000000.0000 BOS","ibc2token555","10.0000 BOS","5000.0000 BOS",
        "100000.0000 BOS",1000,"bos organization","www.bos.com","fixed","0.1000 BOS",0.01,true,"4,BOSPG"]' -p ${contract_token}
    $cleos2 push action ${contract_token} regpegtoken \
        '["1000000000.0000 EOSPG","10.0000 EOSPG","5000.0000 EOSPG",
        "100000.0000 EOSPG",1000,"ibc2token555","eosio.token","4,EOS",true]' -p ${contract_token}
}
init_two











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


transfer(){
    $cleos1 transfer firstaccount ibc2token555 "10.0000 EOS" "ibc receiver=chengsong111" -p firstaccount
    $cleos2 transfer firstaccount ibc2token555 "10.0000 BOS" "ibc receiver=chengsong111" -p firstaccount
}

get_balance(){
    $cleos1 get table ibc2token555 chengsong111 accounts
    $cleos2 get table ibc2token555 chengsong111 accounts
}
get_balance


for i in `seq 1000`; do transfer && sleep 5 ;done


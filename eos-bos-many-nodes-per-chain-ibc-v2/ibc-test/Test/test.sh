#!/usr/bin/env bash





transfer(){
    $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "chengsong111@bos notes infomation" -p firstaccount
}

withdraw(){
    $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "receivereos1@eos notes infomation"]' -p chengsong111
}

transfer_fail(){
    $cleos1 transfer -f firstaccount ibc2token555 "10.0000 EOS" "chengsong123@bos" -p firstaccount
}

withdraw_fail(){
    $cleos2 push action -f ibc2token555 transfer '["chengsong111","ibc2token555","10.0000 EOSPG" "receiver1111@eos"]' -p chengsong111
}


once(){
    for i in `seq 10`; do transfer      && sleep .2 ;done
    for i in `seq  5`; do transfer_fail && sleep .2 ;done
    for i in `seq  5`; do withdraw      && sleep .2 ;done
    for i in `seq  5`; do withdraw_fail && sleep .2 ;done


    for i in `seq 10`; do transfer      && sleep .2 ;done
    for i in `seq  5`; do transfer_fail && sleep .2 ;done
    for i in `seq  5`; do withdraw      && sleep .2 ;done
    for i in `seq  5`; do withdraw_fail && sleep .2 ;done

}




once(){
    for i in `seq 10`; do transfer && sleep .2 ;done

    for i in `seq 2`; do transfer_fail && sleep .2 ;done
    for i in `seq 2`; do transfer_fail && sleep .2 ;done
}

    for i in `seq 10`; do withdraw && sleep .2 ;done
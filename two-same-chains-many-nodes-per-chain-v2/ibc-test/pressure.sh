#!/usr/bin/env bash

. env.sh

receiver=111111111111

send_trxs_c1(){
    for rr in `seq 1000000`; do
        for ii in `seq 100 999`;do $cleos1 transfer -f firstaccount ${receiver} "0.0${ii} EOS" -p firstaccount  ; done
    done
}
send_trxs_c1


send_trxs_c2(){
    for ss in `seq 1000000`; do
        for jj in `seq 100 999`;do $cleos2 transfer -f firstaccount ${receiver} "0.0${jj} BOS" -p firstaccount  ; done
    done
}
send_trxs_c2





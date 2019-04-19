#!/usr/bin/env bash




for i in `seq 100000`; do $cleos1 transfer -f firstaccount 111111111111 "0.0001 EOS" -p firstaccount && sleep .1 ; done

for j in `seq 100000`; do $cleos2 transfer -f firstaccount 111111111111 "0.0001 BOS" -p firstaccount && sleep .1 ; done

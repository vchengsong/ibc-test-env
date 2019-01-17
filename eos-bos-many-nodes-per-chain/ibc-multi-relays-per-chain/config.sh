#!/usr/bin/env bash

read -d '' config_common << EOF
plugin = eosio::chain_api_plugin
plugin = eosio::net_plugin
plugin = eosio::history_api_plugin
p2p-max-nodes-per-host = 50
max-clients = 25

max-transaction-time = 500
#read-mode = head    #read-mode = speculative

contracts-console = true

plugin = eosio::ibc::ibc_plugin
ibc-chain-contract = ibc2chain555
ibc-token-contract = ibc2token555
ibc-relay-name = ibc2relay555
ibc-relay-private-key = EOS5jLHvXsFPvUAawjc6qodxUbkBjWcU1j6GUghsNvsGPRdFV5ZWi=KEY:5K2ezP476ThBo9zSrDqTofzaLiKrQaLEkAzv3USdeaFFrD5LAX1
EOF


read -d '' config_eos_node1 << EOF
http-server-address = 127.0.0.1:28881
p2p-listen-endpoint =   0.0.0.0:19771

p2p-peer-address = localhost:9800
p2p-peer-address = localhost:9801
p2p-peer-address = localhost:9802
p2p-peer-address = localhost:9803
p2p-peer-address = localhost:9804


ibc-listen-endpoint = 0.0.0.0:6101
#ibc-peer-address = 127.0.0.1:6201

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF


read -d '' config_eos_node2 << EOF
http-server-address = 127.0.0.1:28882
p2p-listen-endpoint =   0.0.0.0:19772

p2p-peer-address = localhost:9800
p2p-peer-address = localhost:9801
p2p-peer-address = localhost:9802
p2p-peer-address = localhost:9803
p2p-peer-address = localhost:9804


ibc-listen-endpoint = 0.0.0.0:6102
#ibc-peer-address = 127.0.0.1:6202

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF

read -d '' config_eos_node3 << EOF
http-server-address = 127.0.0.1:28883
p2p-listen-endpoint =   0.0.0.0:19773

p2p-peer-address = localhost:9800
p2p-peer-address = localhost:9801
p2p-peer-address = localhost:9802
p2p-peer-address = localhost:9803
p2p-peer-address = localhost:9804


ibc-listen-endpoint = 0.0.0.0:6103
#ibc-peer-address = 127.0.0.1:6203

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF









read -d '' config_bos_node1 << EOF
http-server-address = 127.0.0.1:28891
p2p-listen-endpoint = 0.0.0.0:28881
p2p-peer-address = localhost:9900
p2p-peer-address = localhost:9901
p2p-peer-address = localhost:9902
p2p-peer-address = localhost:9903
p2p-peer-address = localhost:9904


#ibc-listen-endpoint = 0.0.0.0:6201
ibc-peer-address = 127.0.0.1:6101

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF



read -d '' config_bos_node2 << EOF
http-server-address = 127.0.0.1:28892
p2p-listen-endpoint = 0.0.0.0:28882
p2p-peer-address = localhost:9900
p2p-peer-address = localhost:9901
p2p-peer-address = localhost:9902
p2p-peer-address = localhost:9903
p2p-peer-address = localhost:9904


#ibc-listen-endpoint = 0.0.0.0:6202
ibc-peer-address = 127.0.0.1:6102

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF


read -d '' config_bos_node3 << EOF
http-server-address = 127.0.0.1:28893
p2p-listen-endpoint = 0.0.0.0:28883
p2p-peer-address = localhost:9900
p2p-peer-address = localhost:9901
p2p-peer-address = localhost:9902
p2p-peer-address = localhost:9903
p2p-peer-address = localhost:9904


#ibc-listen-endpoint = 0.0.0.0:6203
ibc-peer-address = 127.0.0.1:6103

ibc-sidechain-id = aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906
ibc-peer-private-key = EOS65jr3UsJi2Lpe9GbxDUmJYUpWeBTJNrqiDq2hYimQyD2kThfAE=KEY:5KHJeTFezCwFCYsaA4Hm2sqEXvxmD2zkgvs3fRT2KarWLiTwv71
EOF










read -d '' logging << EOF
{
  "includes": [],
  "appenders": [{
      "name": "stderr",
      "type": "console",
      "args": {
        "stream": "std_error",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    },{
      "name": "stdout",
      "type": "console",
      "args": {
        "stream": "std_out",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    }
  ],
  "loggers": [{
      "name": "default",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr"
      ]
    }
  ]
}
EOF




read -d '' logging_v << EOF
{
  "includes": [],
  "appenders": [{
      "name": "stderr",
      "type": "console",
      "args": {
        "stream": "std_error",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    },{
      "name": "stdout",
      "type": "console",
      "args": {
        "stream": "std_out",
        "level_colors": [{
            "level": "debug",
            "color": "green"
          },{
            "level": "warn",
            "color": "brown"
          },{
            "level": "error",
            "color": "red"
          }
        ]
      },
      "enabled": true
    }
  ],
  "loggers": [{
      "name": "default",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr"
      ]
    },
    {
      "name": "ibc_plugin_impl",
      "level": "debug",
      "enabled": true,
      "additivity": false,
      "appenders": [
        "stderr"
      ]
    }
  ]
}
EOF


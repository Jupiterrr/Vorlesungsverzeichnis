#!/bin/bash
docker --tlsverify=false -H tcp://172.17.8.101:2375 "$@"

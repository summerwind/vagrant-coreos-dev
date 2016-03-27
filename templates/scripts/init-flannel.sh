#!/bin/sh

set -e

echo "Waiting for etcd..."

while true
do
    IFS=',' read -ra ES <<< "<%= ETCD_ENDPOINTS %>"
    for ETCD in "${ES[@]}"; do
        echo "Trying: $ETCD"
        if [ -n "$(curl --silent "$ETCD/v2/machines")" ]; then
            ACTIVE_ETCD=$ETCD
            break
        fi
        sleep 1
    done
    if [ -n "$ACTIVE_ETCD" ]; then
        break
    fi
done

RES=$(curl --silent -X PUT -d "value={\"Network\":\"<%= K8S_POD_IP_RANGE %>\",\"Backend\":{\"Type\":\"vxlan\"}}" "$ACTIVE_ETCD/v2/keys/coreos.com/network/config?prevExist=false")
if [ -z "$(echo $RES | grep '"action":"create"')" ] && [ -z "$(echo $RES | grep 'Key already exists')" ]; then
    echo "Unexpected error configuring flannel pod network: $RES"
fi

echo "DONE"

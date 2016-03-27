#!/bin/sh

set -e

KUBE_API_URL="http://127.0.0.1:8080"

echo "Waiting for Kubernetes API..."
until curl --silent $KUBE_API_URL
do
    echo "Trying: $KUBE_API_URL"
    sleep 5
done

curl --silent -XPOST -d"$(cat /tmp/files/kubernetes/kube-system.json)" "http://127.0.0.1:8080/api/v1/namespaces" > /dev/null
curl --silent -XPOST -d"$(cat /tmp/files/kubernetes/kube-dns-rc.json)" "http://127.0.0.1:8080/api/v1/namespaces/kube-system/replicationcontrollers" > /dev/null
curl --silent -XPOST -d"$(cat /tmp/files/kubernetes/kube-dns-svc.json)" "http://127.0.0.1:8080/api/v1/namespaces/kube-system/services" > /dev/null

echo "DONE"


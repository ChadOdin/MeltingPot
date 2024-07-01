#!/bin/bash

ETCD_POD=$(kubectl get pods -n $ETCD_NAMESPACE -l component=etcd -o jsonpath='{.items[0].metadata.name}')

kubectl cp ./snapshot.db $ETCD_NAMESPACE/$ETCD_POD:/var/lib/etcd/snapshot.db

kubectl exec -n $ETCD_NAMESPACE $ETCD_POD -- etcdctl snapshot restore /var/lib/etcd/snapshot.db --data-dir /var/lib/etcd
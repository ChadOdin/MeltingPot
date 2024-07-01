#!/bin/bash

ETCD_NAMESPACE="kube-system"
ETCD_POD=$(kubectl get pods -n $ETCD_NAMESPACE -l component=etcd -o jsonpath='{.items[0].metadata.name}')

kubectl exec -n $ETCD_NAMESPACE $ETCD_POD -- etcdctl snapshot save /var/lib/etcd/snapshot.db

kubectl cp $ETCD_NAMESPACE/$ETCD_POD:/var/lib/etcd/snapshot.db ./snapshot.db
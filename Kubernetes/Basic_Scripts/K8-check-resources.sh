#!/bin/bash

NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}

kubectl top nodes
kubectl top pods -n "$NAMESPACE"
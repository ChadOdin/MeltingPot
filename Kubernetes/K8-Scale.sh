#!/bin/bash

DEPLOYMENT_NAME=${DEPLOYMENT_NAME:-""}
REPLICAS=${REPLICAS:-1}
NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}

if [ -z "$DEPLOYMENT_NAME" ] || [ -z "$REPLICAS" ]; then
  echo "Usage: DEPLOYMENT_NAME=<deployment_name> REPLICAS=<replicas> NAMESPACE=<namespace> ./k8s-scale.sh"
  exit 1
fi

kubectl scale deployment "$DEPLOYMENT_NAME" --replicas="$REPLICAS" -n "$NAMESPACE"
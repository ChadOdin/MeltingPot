#!/bin/bash

DEPLOYMENT_NAME=${DEPLOYMENT_NAME:-""}
IMAGE=${IMAGE:-""}
NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}

if [ -z "$DEPLOYMENT_NAME" ] || [ -z "$IMAGE" ]; then
  echo "Usage: DEPLOYMENT_NAME=<deployment_name> IMAGE=<new_image> NAMESPACE=<namespace> ./k8s-rolling-update.sh"
  exit 1
fi

kubectl set image deployment/"$DEPLOYMENT_NAME" *="$IMAGE" -n "$NAMESPACE"
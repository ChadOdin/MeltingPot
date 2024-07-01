#!/bin/bash

POD_NAME=${POD_NAME:-""}
NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}
CONTAINER_NAME=${CONTAINER_NAME:-""}

if [ -z "$POD_NAME" ]; then
  echo "Usage: POD_NAME=<pod_name> NAMESPACE=<namespace> CONTAINER_NAME=<container_name> ./k8s-logs.sh"
  exit 1
fi

if [ -z "$CONTAINER_NAME" ]; then
  kubectl logs "$POD_NAME" -n "$NAMESPACE"
else
  kubectl logs "$POD_NAME" -c "$CONTAINER_NAME" -n "$NAMESPACE"
fi
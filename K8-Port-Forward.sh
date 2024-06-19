#!/bin/bash

POD_NAME=${POD_NAME:-""}
LOCAL_PORT=${LOCAL_PORT:-8080}
REMOTE_PORT=${REMOTE_PORT:-80}
NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}

if [ -z "$POD_NAME" ]; then
  echo "Usage: POD_NAME=<pod_name> LOCAL_PORT=<local_port> REMOTE_PORT=<remote_port> NAMESPACE=<namespace> ./k8s-port-forward.sh"
  exit 1
fi

kubectl port-forward "$POD_NAME" "$LOCAL_PORT":"$REMOTE_PORT" -n "$NAMESPACE"
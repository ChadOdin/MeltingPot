#!/bin/bash

DEPLOYMENT_NAME=${DEPLOYMENT_NAME:-""}
SERVICE_NAME=${SERVICE_NAME:-""}
PORT=${PORT:-80}
TARGET_PORT=${TARGET_PORT:-80}
TYPE=${TYPE:-"ClusterIP"}
NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}

if [ -z "$DEPLOYMENT_NAME" ] || [ -z "$SERVICE_NAME" ]; then
  echo "Usage: DEPLOYMENT_NAME=<deployment_name> SERVICE_NAME=<service_name> PORT=<port> TARGET_PORT=<target_port> TYPE=<type> NAMESPACE=<namespace> ./k8s-expose.sh"
  exit 1
fi

kubectl expose deployment "$DEPLOYMENT_NAME" --name="$SERVICE_NAME" --port="$PORT" --target-port="$TARGET_PORT" --type="$TYPE" -n "$NAMESPACE"
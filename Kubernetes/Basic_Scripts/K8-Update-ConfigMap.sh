#!/bin/bash

CONFIGMAP_NAME=${CONFIGMAP_NAME:-""}
FILE_PATH=${FILE_PATH:-""}
NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}

if [ -z "$CONFIGMAP_NAME" ] || [ -z "$FILE_PATH" ]; then
  echo "Usage: CONFIGMAP_NAME=<configmap_name> FILE_PATH=<file_path> NAMESPACE=<namespace> ./k8s-update-configmap.sh"
  exit 1
fi

kubectl create configmap "$CONFIGMAP_NAME" --from-file="$FILE_PATH" -n "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
#!/bin/bash

NAMESPACE_DEFAULT="default"

DEPLOYMENT_NAME=${DEPLOYMENT_NAME:-""}
IMAGE=${IMAGE:-""}
REPLICAS=${REPLICAS:-1}
RESOURCE_TYPE=${RESOURCE_TYPE:-""}
RESOURCE_NAME=${RESOURCE_NAME:-""}
NAMESPACE=${NAMESPACE:-$NAMESPACE_DEFAULT}

if ! command -v kubectl &> /dev/null; then
  echo "kubectl not found"
  exit 1
fi

function deploy() {
  if [ -z "$DEPLOYMENT_NAME" ] || [ -z "$IMAGE" ] || [ -z "$REPLICAS" ]; then
    echo "Usage: DEPLOYMENT_NAME=<deployment_name> IMAGE=<image> REPLICAS=<replicas> ./k8s-manager.sh deploy"
    exit 1
  fi

  kubectl create deployment "$DEPLOYMENT_NAME" --image="$IMAGE" --replicas="$REPLICAS"
}

function pod_status() {
  kubectl get pods -n "$NAMESPACE"
}

function cleanup() {
  if [ -z "$RESOURCE_TYPE" ] || [ -z "$RESOURCE_NAME" ]; then
    echo "Usage: RESOURCE_TYPE=<resource_type> RESOURCE_NAME=<resource_name> NAMESPACE=<namespace> ./k8s-manager.sh cleanup"
    exit 1
  fi

  kubectl delete "$RESOURCE_TYPE" "$RESOURCE_NAME" -n "$NAMESPACE"
}

function rollout_status() {
  if [ -z "$DEPLOYMENT_NAME" ]; then
    echo "Usage: DEPLOYMENT_NAME=<deployment_name> NAMESPACE=<namespace> ./k8s-manager.sh rollout-status"
    exit 1
  fi

  kubectl rollout status deployment/"$DEPLOYMENT_NAME" -n "$NAMESPACE"
}

function describe() {
  if [ -z "$RESOURCE_TYPE" ] || [ -z "$RESOURCE_NAME" ]; then
    echo "Usage: RESOURCE_TYPE=<resource_type> RESOURCE_NAME=<resource_name> NAMESPACE=<namespace> ./k8s-manager.sh describe"
    exit 1
  fi

  kubectl describe "$RESOURCE_TYPE" "$RESOURCE_NAME" -n "$NAMESPACE"
}

function help() {
  echo "Usage: ./k8s-manager.sh <command>"
  echo "Commands:"
  echo "  deploy"
  echo "    Environment variables:"
  echo "      DEPLOYMENT_NAME=<deployment_name>"
  echo "      IMAGE=<image>"
  echo "      REPLICAS=<replicas>"
  echo "    Example: DEPLOYMENT_NAME=myapp IMAGE=nginx:latest REPLICAS=3 ./k8s-manager.sh deploy"
  echo "  pod-status"
  echo "    Environment variables:"
  echo "      NAMESPACE=<namespace>"
  echo "    Example: NAMESPACE=mynamespace ./k8s-manager.sh pod-status"
  echo "  cleanup"
  echo "    Environment variables:"
  echo "      RESOURCE_TYPE=<resource_type>"
  echo "      RESOURCE_NAME=<resource_name>"
  echo "      NAMESPACE=<namespace>"
  echo "    Example: RESOURCE_TYPE=deployment RESOURCE_NAME=myapp NAMESPACE=mynamespace ./k8s-manager.sh cleanup"
  echo "  rollout-status"
  echo "    Environment variables:"
  echo "      DEPLOYMENT_NAME=<deployment_name>"
  echo "      NAMESPACE=<namespace>"
  echo "    Example: DEPLOYMENT_NAME=myapp NAMESPACE=mynamespace ./k8s-manager.sh rollout-status"
  echo "  describe"
  echo "    Environment variables:"
  echo "      RESOURCE_TYPE=<resource_type>"
  echo "      RESOURCE_NAME=<resource_name>"
  echo "      NAMESPACE=<namespace>"
  echo "    Example: RESOURCE_TYPE=deployment RESOURCE_NAME=myapp NAMESPACE=mynamespace ./k8s-manager.sh describe"
}

if [ $# -lt 1 ]; then
  help
  exit 1
fi

COMMAND=$1
shift

case "$COMMAND" in
  deploy)
    deploy "$@"
    ;;
  pod-status)
    pod_status "$@"
    ;;
  cleanup)
    cleanup "$@"
    ;;
  rollout-status)
    rollout_status "$@"
    ;;
  describe)
    describe "$@"
    ;;
  *)
    echo "Unknown command: $COMMAND"
    help
    exit 1
    ;;
esac
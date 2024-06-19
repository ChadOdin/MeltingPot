#!/bin/bash

NAMESPACE_DEFAULT="default"

if ! command -v kubectl &> /dev/null; then
  echo "kubectl could not be found, please install it and ensure it is in your PATH."
  exit 1
fi

function deploy() {
  local deployment_name=$1
  local image=$2
  local replicas=$3

  if [ -z "$deployment_name" ] || [ -z "$image" ] || [ -z "$replicas" ]; then
    echo "Usage: ./k8s-manager.sh deploy <deployment_name> <image> <replicas>"
    exit 1
  fi

  kubectl create deployment "$deployment_name" --image="$image" --replicas="$replicas"
}

function pod_status() {
  local namespace=${1:-$NAMESPACE_DEFAULT}

  kubectl get pods -n "$namespace"
}

function cleanup() {
  local resource_type=$1
  local resource_name=$2
  local namespace=${3:-$NAMESPACE_DEFAULT}

  if [ -z "$resource_type" ] || [ -z "$resource_name" ]; then
    echo "Usage: ./k8s-manager.sh cleanup <resource_type> <resource_name> <namespace>"
    exit 1
  fi

  kubectl delete "$resource_type" "$resource_name" -n "$namespace"
}

function rollout_status() {
  local deployment_name=$1
  local namespace=${2:-$NAMESPACE_DEFAULT}

  if [ -z "$deployment_name" ]; then
    echo "Usage: ./k8s-manager.sh rollout-status <deployment_name> <namespace>"
    exit 1
  fi

  kubectl rollout status deployment/"$deployment_name" -n "$namespace"
}

function describe() {
  local resource_type=$1
  local resource_name=$2
  local namespace=${3:-$NAMESPACE_DEFAULT}

  if [ -z "$resource_type" ] || [ -z "$resource_name" ]; then
    echo "Usage: ./k8s-manager.sh describe <resource_type> <resource_name> <namespace>"
    exit 1
  fi

  kubectl describe "$resource_type" "$resource_name" -n "$namespace"
}

function help() {
  echo "Usage: ./k8s-manager.sh <command> [<args>...]"
  echo "Commands:"
  echo "  deploy <deployment_name> <image> <replicas>"
  echo "  pod-status <namespace>"
  echo "  cleanup <resource_type> <resource_name> <namespace>"
  echo "  rollout-status <deployment_name> <namespace>"
  echo "  describe <resource_type> <resource_name> <namespace>"
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
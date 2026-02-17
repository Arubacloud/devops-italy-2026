#!/bin/bash
set -e

KUBECONFIG_PATH=$1

echo "Waiting for Kubernetes API to be ready..."
for i in {1..60}; do
  if kubectl --kubeconfig="$KUBECONFIG_PATH" cluster-info &>/dev/null; then
    echo "Kubernetes API is ready"
    exit 0
  fi
  echo "Waiting for API... (attempt $i/60)"
  sleep 5
done

echo "Timeout waiting for Kubernetes API"
exit 1

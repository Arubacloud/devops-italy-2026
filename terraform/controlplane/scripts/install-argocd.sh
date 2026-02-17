#!/bin/bash
set -e

KUBECONFIG_PATH=$1

echo "Installing ArgoCD..."
kubectl --kubeconfig="$KUBECONFIG_PATH" apply --server-side --force-conflicts -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD to be ready..."
kubectl --kubeconfig="$KUBECONFIG_PATH" wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
kubectl --kubeconfig="$KUBECONFIG_PATH" wait --for=condition=available --timeout=300s deployment/argocd-repo-server -n argocd
kubectl --kubeconfig="$KUBECONFIG_PATH" wait --for=condition=available --timeout=300s deployment/argocd-applicationset-controller -n argocd

echo "ArgoCD installation complete"

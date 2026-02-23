#!/bin/bash
set -e

KUBECONFIG_PATH=$1
SCRIPT_DIR=$2

echo "Configuring repository access..."
kubectl --kubeconfig="$KUBECONFIG_PATH" -n argocd patch configmap argocd-cm --type merge -p '{"data":{"repositories":"- url: https://github.com/Arubacloud/devops-italy-2026.git\n  type: git\n  name: devops-italy-2026"}}'

echo "Applying ArgoCD bootstrap application (App of Apps)..."
kubectl --kubeconfig="$KUBECONFIG_PATH" apply -f "$SCRIPT_DIR/../../argocd/bootstrap/main.yaml"

echo "ArgoCD bootstrap complete"
echo ""
echo "=================================================="
echo "ArgoCD has been installed successfully!"
echo "=================================================="
echo ""
echo "✅ Repository configured: https://github.com/Arubacloud/devops-italy-2026.git"
echo ""
echo "To access ArgoCD UI:"
echo "1. Get admin password:"
echo "   kubectl --kubeconfig=$KUBECONFIG_PATH -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo ""
echo "2. Port forward to UI:"
echo "   kubectl --kubeconfig=$KUBECONFIG_PATH port-forward svc/argocd-server -n argocd 8080:443"
echo ""
echo "3. Access: https://localhost:8080"
echo "   Username: admin"
echo ""
echo "=================================================="

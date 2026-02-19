# Backstage Catalog

This directory contains Backstage catalog entities including templates for creating ArubaCloud resources.

## Files

- **catalog-info.yaml** - Catalog location descriptor that references all templates
- **project-template.yaml** - Template for creating ArubaCloud Project resources
- **blockstorage-template.yaml** - Template for creating ArubaCloud BlockStorage volumes

## How to Register Templates

### Option 1: Manual Registration via UI (Recommended for testing)

1. Commit this directory to your Git repository
2. Deploy Backstage (see below)
3. Access Backstage: `kubectl port-forward -n backstage svc/backstage 7007:7007`
4. Open http://localhost:7007
5. Click **Create** in the sidebar → **Register Existing Component**
6. Enter the URL to your `catalog-info.yaml` file:
   - GitHub: `https://raw.githubusercontent.com/your-org/your-repo/main/argocd/backstage-catalog/catalog-info.yaml`

### Option 2: Automatic Registration via Configuration

Update the Backstage `app-config` in backstage.yaml to include your Git repository URL.

## Deploying Backstage

```bash
# 1. Apply RBAC configuration (creates namespace and permissions)
kubectl apply -f ../applications/backstage-rbac.yaml

# 2. Deploy Backstage
kubectl apply -f ../applications/backstage.yaml

# 3. Wait for deployment
kubectl wait --for=condition=available --timeout=300s deployment/backstage -n backstage

# 4. Access the UI
kubectl port-forward -n backstage svc/backstage 7007:7007
```

Then open http://localhost:7007

## Using the Templates

Once registered, the templates will appear in **Create** > Browse templates.

### Project Template
- Creates ArubaCloud Project CRDs
- Configure: name, namespace, tenant, description, tags
- Set as default project option

### BlockStorage Template
- Creates ArubaCloud BlockStorage CRDs
- Configure: name, size, location, data center
- Optional: Make bootable with OS image
- Optional: Link to existing Project

## Example Resources Created

**Project**:
```yaml
apiVersion: arubacloud.com/v1alpha1
kind: Project
metadata:
  name: my-project
  namespace: default
spec:
  tenant: my-tenant
  description: Production project
  tags:
    - production
  default: false
```

**BlockStorage**:
```yaml
apiVersion: arubacloud.com/v1alpha1
kind: BlockStorage
metadata:
  name: my-volume
  namespace: default
spec:
  tenant: my-tenant
  sizeGb: 100
  location:
    value: ITBG-Bergamo
  dataCenter: ITBG-1
  billingPeriod: Month
  bootable: true
  image: LU20-001
  projectReference:
    name: my-project
    namespace: default
```

## Prerequisites

- Kubernetes cluster with CRDs installed (ArubaCloud operator)
- Backstage deployed with proper RBAC permissions
- Git repository containing these templates

## Learn More

- [Backstage Templates Documentation](https://backstage.io/docs/features/software-templates/)
- [Kubernetes Plugin](https://backstage.io/docs/features/kubernetes/)

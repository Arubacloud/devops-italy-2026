# DevOps Italy 2026 – Control Plane & Internal Developer Platform

Infrastructure as Code and GitOps for an **ArubaCloud-based control plane** with managed Kubernetes, Argo CD, Vault, the ArubaCloud Resource Operator, and Backstage as the Internal Developer Platform (IDP).

## Architecture

The control plane runs on **ArubaCloud Managed Kubernetes (KaaS)**. All cloud resources are provisioned with the **ArubaCloud Terraform provider**. The cluster is then managed by:

| Component | Role |
|-----------|------|
| **Argo CD** | GitOps: syncs applications from this repo. A bootstrap app watches `argocd/applications/` and creates an Application per YAML file (App of Apps). |
| **ArubaCloud Resource Operator** | Reconciles ArubaCloud custom resources (e.g. `Project`) in the cluster. Uses **Vault** (AppRole) to obtain tenant API credentials. |
| **Vault** | Stores tenant credentials (e.g. API key/secret per tenant). The operator reads from Vault; Backstage and other IDP flows do not hold credentials. |
| **Backstage** | Internal Developer Platform frontend: catalog, software templates, and custom resource UIs (e.g. create ArubaCloud Project CR and open a PR to this GitOps repo). |

```
┌─────────────────────────────────────────────────────────────────────────┐
│  ArubaCloud (Terraform)                                                   │
│  • Project, VPC, Subnet, KaaS cluster, kubeconfig                         │
└─────────────────────────────────────────────────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  Control plane (Kubernetes on ArubaCloud KaaS)                           │
│  ┌─────────────┐  ┌──────────────────────────┐  ┌─────────────────────┐ │
│  │ Argo CD     │  │ ArubaCloud Resource      │  │ Vault                │ │
│  │ (GitOps)    │  │ Operator (CRs → API)     │◄─┤ (tenant credentials)│ │
│  └──────┬──────┘  └──────────────────────────┘  └─────────────────────┘ │
│         │                                                                 │
│         │  syncs argocd/applications/                                     │
│         ▼                                                                 │
│  ┌─────────────┐                                                          │
│  │ Backstage   │  IDP: catalog, templates, CR UIs (e.g. Project → PR)    │
│  └─────────────┘                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Try it out

1. **Prerequisites**
   - [Terraform](https://www.terraform.io/downloads) >= 1.0  
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)  
   - ArubaCloud account and API credentials  
   - Bash (e.g. WSL on Windows)

2. **Configure variables**
   - Go to `terraform/controlplane`.
   - Copy the example vars and fill in your values:
     ```bash
     cp terraform.tfvars.example terraform.tfvars
     ```
   - Edit `terraform.tfvars`: set `arubacloud_api_key`, `arubacloud_api_secret`, and any KaaS options (name, location, node pool, etc.). See `variables.tf` and the example file for all options.

3. **Provision the control plane**
   - From the repo root:
     ```bash
     cd terraform/controlplane
     terraform init
     terraform apply
     ```
   - Terraform will create the ArubaCloud project/network, the KaaS cluster, install Argo CD, run the bootstrap script (apply `argocd/projects/`, configure repo, apply App of Apps). When it finishes, use the printed commands to get the Argo CD admin password and port-forward to the UI.

4. **After apply**
   - Argo CD will sync applications from this repo (Vault, vault-config, ArubaCloud operator, Backstage, etc.).  
   - Use Backstage to create ArubaCloud Project CRs via the template; it will open a PR to this repo and, after merge, Argo CD will apply the resource.

## Repository layout

- **`terraform/controlplane/`** – Terraform for ArubaCloud project, VPC, KaaS, Argo CD install + bootstrap.  
- **`argocd/projects/`** – AppProject definitions (applied by bootstrap script).  
- **`argocd/bootstrap/`** – Root Application that watches `argocd/applications/`.  
- **`argocd/applications/`** – One Argo CD Application per file (Vault, operator, Backstage, etc.).  
- **`others/backstage/`** – Backstage templates and GitOps skeleton (e.g. ArubaCloud Project CR).

## Learning resources

- [Argo CD](https://argo-cd.readthedocs.io/)
- [Kubernetes](https://kubernetes.io/docs/)
- [Terraform](https://www.terraform.io/docs)
- [ArubaCloud KaaS](https://www.cloud.it/kubernetes)

## Contributing

Contributions are welcome. This is a reference control plane and IDP setup that you can adapt to your needs.

## License

[LICENSE](LICENSE)

---

For issues, check Terraform and Kubernetes logs or the documentation above.


# AI Context – Internal Developer Platform on ArubaCloud KaaS

This document provides architectural and operational context for AI-assisted development
(Cursor IDE, LLMs) working on this repository.

The goal is to avoid repeating explanations and to enable accurate, consistent answers
when designing or modifying platform components—especially Backstage integration.

---

## 1. Platform Overview

This repository implements an **Internal Developer Platform (IDP)** running on  
**ArubaCloud Kubernetes as a Service (KaaS)**.

The platform is installed and managed using **Terraform** and **GitOps (Argo CD)**.

### Primary goals
- Provide a standardized Kubernetes control plane
- Automate application and infrastructure deployment
- Enable self-service for developers via Backstage

---

## 2. Bootstrap & Installation Flow

### 2.1 Terraform Entry Point

Users install the platform by running:

```bash
cd terraform/controlplane
terraform apply
```

### 2.2 Argo CD Bootstrap Pattern

The bootstrap Argo CD application is defined at:

```bash
argocd/bootstrap/main.yml
```

This bootstrap application:

- Configures Argo CD itself
- Automatically creates Argo CD Applications defined under:

```bash
argocd/applications/
```

This enables a GitOps-driven, self-managing Argo CD setup. This part of the system is working correctly.

## 3. Argo CD Application Management

- All workloads (including platform components) are deployed via Argo CD
- Applications are defined declaratively under argocd/applications/
- Argo CD is the single source of truth for Kubernetes resources

## 4. Backstage Integration (Current State)

### 4.1 Backstage Deployment
- Backstage is already running in a Kubernetes cluster
- Backstage itself is deployed via Argo CD
- RBAC resources for Backstage have been applied using:

```bash
backstage-rbac.yaml
```
However, Backstage does not yet provide a working self-service UI for creating platform resources.

### 4.2 Custom Kubernetes APIs
- The Kubernetes cluster contains Custom Resource Definitions (CRDs)
- These CRDs live under the API group: **arubacloud.com**

These custom resources represent platform-level abstractions, such as:
- Services
- Environments
- Workloads
- Infrastructure components

## 5. Desired Outcome (Target State)

The platform should provide a frontend software catalog and self-service experience
using Backstage.

**Expected user flow**

1. Users open Backstage
2. Users select a Template from the Software Templates page
3. A form (Template Wizard) collects user input
4. Backstage creates a Custom Resource (CR) in Kubernetes
under the arubacloud.com API group
5. The resource is then:
   - Reconciled by a Kubernetes controller, or
   - Picked up and deployed by Argo CD via GitOps

## 6. Known Gaps / Open Questions

The following aspects are unclear or missing and require guidance:
- How to correctly define **Backstage Templates** for Kubernetes CRDs
- Whether a **custom scaffolder action** is required
- How Backstage should authenticate to the Kubernetes API
- How permissions (**RBAC, ServiceAccounts**) should be configured
- Whether Backstage should:
  - Apply CRs directly to the cluster, or
  - Commit YAML to Git and let Argo CD apply it

## 7. Assumptions & Constraints
- Argo CD is already installed and functional
- GitOps is the preferred deployment model
- Backstage should **not** bypass Argo CD unless explicitly required
- Simplicity and maintainability are preferred over custom plugins
- The user is **not deeply experienced with Backstage**

## 8. Expectations from AI Assistance
When using this context, the AI should:
- Explain Backstage concepts clearly (Scaffolder, Templates, Actions)
- Propose a **recommended architecture**
- Prefer **GitOps-based solutions**
- Provide **concrete YAML examples**
- Clearly indicate **what is missing** in the current setup
- Avoid generic or high-level explanations without actionable steps

## 9. Preferred Outputs
The most useful outputs include:
- Backstage template YAML examples
- File placement recommendations
- Minimal working configurations
- Step-by-step implementation guidance
- Clear explanations of trade-offs

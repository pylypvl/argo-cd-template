# argo-cd

# argo-cd

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes applications. It automates the deployment of applications to Kubernetes clusters by using Git repositories as the source of truth for application configuration and manifests. With Argo CD, you can easily manage and synchronize the state of your applications across multiple clusters, track changes, roll back to previous versions, and enforce consistency in your deployment process. It provides a web-based UI and CLI for managing applications and integrates seamlessly with Git repositories, Kubernetes, and other CI/CD tools.

Prerequisite:
You need to have an EKS cluster deployed (although you are not limited to using only EKS; you can deploy to other clusters as long as you have appropriate instances for it).
Run:

terraform init
terraform apply

When the pods are deployed, you can check how many pods and services were deployed with respect to Argo CD.

Then, you will have to run the following command:

kubectl get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

In order to access the application through the UI, you need to run the following command:
Example:

kubectl port-forward service/argocd-server 8090:80

Access the application by navigating to:
http://localhost:8090/

To retrieve the initial password through the terminal, use the following command:

kubectl get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

Example of the password:
huKAKn3R9QgsQ53%


When you attempt to access the UI page, you will need to use the admin username and password found in the terminal. However, you may encounter a bug preventing you from accessing the page. To fix it, run the following set of commands:


argocd account bcrypt --password 1huKAKn3R9QgsQ53%

kubectl patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$yRBjtumzG6E5Bq6NvudeWu9aBtB8TV0ChWp8rYdIUlqxaf1bcYbqe%",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

You can deploy Argo CD using Helm charts as well. However, you will encounter the same bug when accessing the page through the UI

Advantages of using ArgoCD:

GitOps Workflow: Enables declarative, Git-centric continuous delivery for Kubernetes applications.

Automated Deployments: Automates application deployments, ensuring consistency and reliability.

Version Control: Uses Git as the source of truth for application configurations and manifests, allowing for easy tracking of changes.

Rollback Capabilities: Facilitates easy rollback to previous application versions in case of errors or issues.

Multi-cluster Management: Supports managing applications across multiple Kubernetes clusters from a single control plane.

Web UI and CLI: Provides a user-friendly web-based UI and command-line interface for managing applications and deployments.

Integration: Integrates seamlessly with Git repositories, Kubernetes, and CI/CD tools, enhancing developer productivity and collaboration.

Policy Enforcement: Allows for policy-driven deployment strategies, including automated synchronization, health checks, and validation.

In summary, Argo CD simplifies and streamlines the deployment process for Kubernetes applications while ensuring consistency, reliability, and scalability.



When you want to update to another cluster or environment, you would have to make a copy of these two values for the alpha, beta, staging, and production environments, and paste them under these values. This should do the trick for us.

module "argocd_dev" {
  source           = "./terraform_argocd_eks"
  eks_cluster_name = "gamania-dev"
  chart_version    = "5.46.7"
}


#Can be deployed ONLY after ArgoCD deployment: depends_on = [module.argocd_dev]
# module "argocd_dev_root" {
#   source             = "./terraform_argocd_root_eks"
#   eks_cluster_name   = "gamania-dev"
#   git_source_path    = "demo-dev/applications"
#   git_source_repoURL = git@github.com:pylypvl/Helm-charts-examples.git"
# }

Example:
module "argocd_dev" {
  source           = "./terraform_argocd_eks"
  eks_cluster_name = "Gamania-prod"
  chart_version    = "5.46.7"
}


#Can be deployed ONLY after ArgoCD deployment: depends_on = [module.argocd_dev]
# module "argocd_dev_root" {
#   source             = "./terraform_argocd_root_eks"
#   eks_cluster_name   = "Gamania-prod"
#   git_source_path    = "demo-prod/applications"
#   git_source_repoURL = git@github.com:pylypvl/Helm-charts-examples.git"
# }

Unfortunately, I did not had enought time to test perfectly :(
This should work in theory.

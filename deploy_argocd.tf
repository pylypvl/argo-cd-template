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
#   git_source_repoURL = "git@github.com:pylypvl/Helm-charts-examples.git"
# }

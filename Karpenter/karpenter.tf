module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn

  # Re-use the IAM role from the managed node group for Karpenter nodes
  node_iam_role_arn = module.eks.eks_managed_node_groups["base"].iam_role_arn

  # Subnets where Karpenter is allowed to launch nodes
  subnet_ids = module.vpc.private_subnets

  # Security group for Karpenter nodes (reuse worker SG)
  security_group_ids = [module.eks.node_security_group_id]

  # Default instance profile for Karpenter-launched nodes
  create_instance_profile = true

  # Optional Helm values overrides
  # Common: limit CPU/RAM of controller, enable metrics, etc.
  helm_chart_version = "v1.0.0" # <-- check karpenter.sh for latest version
}

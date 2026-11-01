module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_config  = var.public_subnet_config
  private_subnet_config = var.private_subnet_config
  cluster_name          = var.cluster_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = [for v in module.vpc.private_subnets : v.id]
  node_groups     = var.node_groups
}

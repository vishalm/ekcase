module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~>2.6.0"

  name = "umsl-app-${var.app_environment}"
  cidr = "10.0.0.0/16"
  azs = var.azs
  public_subnets = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"]
  enable_dns_hostnames = true

  tags = {
    project = "umsl-app"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

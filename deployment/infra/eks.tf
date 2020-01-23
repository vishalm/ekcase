module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~>5.1.0"
  cluster_name = var.eks_cluster_name
  subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id

  worker_groups_launch_template = [
    {
      name = "${var.app_environment}-worker-grp"
      instance_type = var.eks_worker_instance_type
      asg_max_size = 3
      asg_desired_capacity = 3
      public_ip = true
      tags = [
        {
          key = "project"
          value = "umsl-app"
          propagate_at_launch = true
        }]
    },
  ]
}

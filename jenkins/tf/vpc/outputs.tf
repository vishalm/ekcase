# vpc
output "vpc_id" {
  description = "vpc id"
  value       = module.vpc.vpc_id
}

# cidr blocks lists
output "vpc_cidr_block" {
  description = "vpc cidr block"
  value       = module.vpc.vpc_cidr_block
}


# subnet list
output "private_subnets" {
  description = "private subnets list"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "public subnets list"
  value       = module.vpc.public_subnets
}

# nat public ip list
output "nat_public_ips" {
  description = "nat public ips list"
  value       = module.vpc.nat_public_ips
}

# list of azs
output "azs" {
  description = "list of azs"
  value       = module.vpc.azs
}


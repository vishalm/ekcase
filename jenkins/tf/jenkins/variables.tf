variable "instance_type" {
  type = string
  description = "master type"
}

variable "ami_id" {
  type = string
  description = "master ami id"
}

variable "key_name" {
  type = string
  description = "master ssh key"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "vpc_cidr" {
  type = list(string)
  description = "vpc cidr list"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "list of private subnets"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "list of public subnets"
}

variable "ssh_allowed_cidr" {
  type = list(string)
  description = "list of allowed cidr"
}

variable "resources_tags" {
  type = map
  description = "tags for resources"
}

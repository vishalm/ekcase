variable "region" {
  default = "ap-south-1"
}

variable "azs" {
  type = list(string)
  default = ["ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"]
}

variable "eks_worker_instance_type" {
  default = "t3.micro"
}

variable "eks_cluster_name" {
  default = "umsl-app"
}

variable "app_environment" {
  default = "dev"
}

variable "git_repo_name" {
  default = "umsl-app"
}

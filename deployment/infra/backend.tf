terraform {
  required_version = ">= 0.12.0"
}

terraform {
  backend "s3" {
    bucket = "ek-case-deployment"
    key = "terraform/terraform.tfstate"
    region = "ap-southeast-1"
  }
}


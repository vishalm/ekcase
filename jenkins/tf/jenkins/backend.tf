# Storing terraform state in s3
terraform {
backend "s3" {
    bucket = "jenkins-tf-1"
    key    = "tfstate/jenkinsinfra.tfstate"
    region = "ap-southeast-1"
  }
}

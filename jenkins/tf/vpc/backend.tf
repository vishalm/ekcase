terraform {
  backend "s3" {
    bucket = "jenkins-tf-1"
    key    = "tfstate/vpc.tfstate"
    region = "ap-southeast-1"
  }
}
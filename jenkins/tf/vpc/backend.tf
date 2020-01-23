terraform {
  backend "s3" {
    bucket = "jenkins-ek"
    key    = "tfstate/vpc.tfstate"
    region = "ap-southeast-1"
  }
}
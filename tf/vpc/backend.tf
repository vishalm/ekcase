terraform {
  backend "s3" {
    bucket = "jenkins-casestudy-ek"
    key    = "tfstate/vpc.tfstate"
    region = "ap-southeast-1"
  }
}
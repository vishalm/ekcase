instance_type      = "t2.micro"
ami_id             = "ami-0998d6a73e1a7bbed"
key_name           = "jenkins-ek"
vpc_id             = "vpc-0565a971b3ecf4049"
vpc_cidr           = ["10.0.0.0/16"]
ssh_allowed_cidr   = ["10.0.0.0/16"]
private_subnet_ids = [
  "subnet-06f13f9e665f856fa",
  "subnet-01d786e191e5b0ada",
  "subnet-0cb817413a89af10c"
]
public_subnet_ids = [
  "subnet-0ca2ee164e4f803c0",
  "subnet-0778ab248bc864c4b",
  "subnet-05a5b2b08ce185147"
]

resources_tags = {
  CostCenter  = "project1 cost center"
  Name        = "jenkins-ek",
  Application = "CI CD Platform Jenkins"
}

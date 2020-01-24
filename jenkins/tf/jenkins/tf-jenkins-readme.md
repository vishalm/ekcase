To provision jenkins and monitoring infrastructure with terraform.

```
terraform init
terraform validate
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars
```
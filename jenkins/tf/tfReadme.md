
```
terraform init
terraform plan
terraform apply
```

### Output

```
Apply complete! Resources: 25 added, 0 changed, 0 destroyed.

Outputs:

azs = [
  "ap-southeast-1a",
  "ap-southeast-1b",
  "ap-southeast-1c",
]
nat_public_ips = [
  "52.77.182.28",
]
private_subnets = [
  "subnet-0423ec9377342c232",
  "subnet-04b69f7005c19ab01",
  "subnet-02f9a2d0e49711335",
]
public_subnets = [
  "subnet-00c868d4104a90add",
  "subnet-0b0a316bda016174b",
  "subnet-0ab665657fad2c1c6",
]
vpc_cidr_block = 10.0.0.0/16
vpc_id = vpc-043e08a0c2cf6a6c8
```


env = "local"

availability_zone = "eu-west-3b"

cidr_block = "10.90.8.0/21" # 10.90.8.0 to 10.90.15.255

public_subnets = [
  "10.90.8.64/26",
  "10.90.8.0/26",
  "10.90.8.128/26"
]

private_subnets = [
  "10.90.9.0/26",
  "10.90.9.64/26",
  "10.90.9.128/26"
]

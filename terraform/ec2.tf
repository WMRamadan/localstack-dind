# Define VPC
resource "aws_vpc" "example" {
  cidr_block = var.cidr_block
  tags = {
    Name = "example-vpc"
  }
}

# Define Internet Gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
  tags = {
    Name = "example-igw"
  }
}

# Define Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "public_subnet_association" {
  count = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zone
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Use a dummy AMI for LocalStack
  instance_type = "t2.micro"
  subnet_id     = element(aws_subnet.public_subnets.*.id, 0) # Choose the first public subnet

  tags = {
    Name = "example-instance"
  }
}
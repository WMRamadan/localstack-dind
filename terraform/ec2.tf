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

# Define EC2 instance in the public subnet
resource "aws_instance" "public_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Use a dummy AMI for LocalStack
  instance_type = "t2.micro"
  subnet_id     = element(aws_subnet.public_subnets.*.id, 0) # Choose the first public subnet

  tags = {
    Name = "public-instance"
  }
}

# Define EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Use a dummy AMI for LocalStack
  instance_type = "t2.micro"
  subnet_id     = element(aws_subnet.private_subnets.*.id, 0)  # Use the first private subnet
  associate_public_ip_address = false        # No public IP since it's in a private subnet

  tags = {
    Name = "private-instance"
  }

  # Security group to allow internal communication within VPC
  security_groups = [aws_security_group.private_sg.id]
}

# Security group for the private instance
resource "aws_security_group" "private_sg" {
  name        = "private-instance-sg"
  description = "Allow internal traffic to the private instance"
  vpc_id      = aws_vpc.example.id

  # Allow inbound traffic from within the VPC
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]  # Allow traffic from within the VPC
  }

  # Allow all outbound traffic within the VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "private-route-table"
  }
}

# Associate the private subnets with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  count = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

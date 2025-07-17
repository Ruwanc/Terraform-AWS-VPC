#Create VPC
resource "aws_vpc" "uat-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "UAT-VPC"
  }
}

# Create Subnet1 - Public Subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.uat-vpc.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "Public-Subnet-1"
  }
}

# Create Internet Gateway for public subnet
resource "aws_internet_gateway" "uat-igw" {
  vpc_id = aws_vpc.uat-vpc.id

  tags = {
    Name = "uat-igw"
  }
}

# Internet gatway attachment to VPC (This block is not reuired since the internet gateway is automatically attached to the VPC when creating the internet gateway with the vpc id tag)
# resource "aws_internet_gateway_attachment" "vpc-igw-attachment" {
#   internet_gateway_id = aws_internet_gateway.uat-igw.id
#   vpc_id              = aws_vpc.uat-vpc.id
# }

# Create Route table for public subnet
resource "aws_route_table" "uat-public-rt" {
  vpc_id = aws_vpc.uat-vpc.id

  # since this is exactly the route AWS will create, the route will be adopted
  route {
    cidr_block = "10.1.0.0/16"
    gateway_id = "local"
  }
}

# Create route table association with public subnet
resource "aws_route_table_association" "route-table-association-with-public-subnet" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.uat-public-rt.id
}

# Create default route for public subnet
resource "aws_route" "default_route_to_internet" {
  route_table_id         = aws_route_table.uat-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.uat-igw.id
}

# Create Network ACL for public subnet
resource "aws_network_acl" "nacl-public-subnet-1" {
  vpc_id = aws_vpc.uat-vpc.id
}

resource "aws_network_acl_rule" "nacl-public-subnet-1-allow-all-ingress" {
  network_acl_id = aws_network_acl.nacl-public-subnet-1.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  #If the value of protocol is -1 or all, the from_port and to_port values will be ignored and the rule will apply to all ports
  #   from_port      = 22
  #   to_port        = 22
}

resource "aws_network_acl_rule" "nacl-public-subnet-1-allow-all-egress" {
  network_acl_id = aws_network_acl.nacl-public-subnet-1.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  #If the value of protocol is -1 or all, the from_port and to_port values will be ignored and the rule will apply to all ports
  #   from_port      = 22
  #   to_port        = 22
}
#Create VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_range
  tags = {
    Name = "${var.module_environment}-${var.module_project_name}-vpc"
  }
}


# Create Subnet1 - Public Subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr_range

  tags = {
    Name = "${var.module_environment}-${var.module_project_name}-Public-Subnet-1"
  }
}

# Create Internet Gateway for public subnet
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.module_environment}-${var.module_project_name}-igw"
  }
}

# define default route table for VPC
resource "aws_default_route_table" "this" {
  default_route_table_id =  aws_vpc.this.default_route_table_id
  route {
    cidr_block = var.vpc_cidr_range #VPC cider block here
    gateway_id = "local"
  }
}

 # Create Route table for public subnet using route table resource.
 # Define every route associated to this public subnet
 resource "aws_route_table" "route_table_public_sb"{
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.vpc_cidr_range #Public subnet CIDR block here
    gateway_id = "local"
  }

  route{
    cidr_block = "0.0.0.0/0" # Default route to the internet
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.module_environment}-${var.module_project_name}-public-sunbet-rt"
  }
 }



# Create route table association with public subnet
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.route_table_public_sb.id
}

# # Create default route for public subnet
# resource "aws_route" "default_route_to_internet" {
#   route_table_id         = aws_route_table.uat-public-rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.uat-igw.id
# }

# Create network ACL in vpc
resource "aws_network_acl" "nacl-public-subnet" {
  vpc_id = aws_vpc.this.id
}

# Associate network ACL with public subnet
resource "aws_network_acl_association" "nacl-associate-public-subnet" {
  network_acl_id = aws_network_acl.nacl-public-subnet.id
  subnet_id      = aws_subnet.public.id
}

# Ingress rule for public subnet
resource "aws_network_acl_rule" "nacl-public-subnet-1-allow-all-ingress" {
  network_acl_id = aws_network_acl.nacl-public-subnet.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  #If the value of protocol is -1 or all, the from_port and to_port values will be ignored and the rule will apply to all ports
  #   from_port      = 22
  #   to_port        = 22
}

# Egress rule for public subnet
resource "aws_network_acl_rule" "nacl-public-subnet-1-allow-all-egress" {
  network_acl_id = aws_network_acl.nacl-public-subnet.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  #If the value of protocol is -1 or all, the from_port and to_port values will be ignored and the rule will apply to all ports
  #   from_port      = 22
  #   to_port        = 22
}
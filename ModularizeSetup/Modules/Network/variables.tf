#define environment name
variable "module_environment" { type = string }
#define project name
variable "module_project_name" { type = string }

# define VPC CIDR range
variable "vpc_cidr_range"{
    description = "CIDR range for the VPC"
    type = string
    default = "10.0.0/16"
}

# define VPC public subnet CIDR range
variable "public_subnet_cidr_range" {
  description = "CIDR range for the public subnet"
  type = string
  default = "10.0.1.0/24"
}
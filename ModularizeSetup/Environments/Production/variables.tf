#define environment name
variable "prod_environment" {
  type    = string
  default = "Production"
}
#define project name
variable "prod_project_name" {
  type    = string
  default = "VPC-Project"
}

# define VPC CIDR range
variable "prod_vpc_cidr_range" {
  description = "CIDR range for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

# define VPC public subnet CIDR range
variable "prod_public_subnet_cidr_range" {
  description = "CIDR range for the public subnet"
  type        = string
  default     = "10.1.1.0/24"
}
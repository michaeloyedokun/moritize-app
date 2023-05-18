variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
}

variable "vpc_cidr_block" {
   description = "CIDR block for VPC"
   type = string
   default = "10.0.0.0/16"
}

# variable "private_subnet_cidr_block" {
#    description = "CIDR block for private subnet"
#    type = string
#    default = "10.0.1.0/24"
# }

# variable "public_subnet_cidr_block" {
#    description = "CIDR block for public subnet"
#    type = string
#    default = "10.0.0.0/24"
# }

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "aws_profile" {
  description = "AWS profile"
}


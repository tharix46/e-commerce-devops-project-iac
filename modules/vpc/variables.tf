variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_config" {
  description = "Public subnet configs keyed by AZ"
  type = map(object({
    new_bits = number
    net_num  = number
  }))
}

variable "private_subnet_config" {
  description = "Private subnet configs keyed by AZ"
  type = map(object({
    new_bits = number
    net_num  = number
  }))
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
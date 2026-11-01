variable "region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_config" {
  description = "Public subnet configs keyed by AZ"
  type = map(object({
    new_bits = number
    net_num  = number
  }))
  default = {
    "us-east-1a" = { new_bits = 8, net_num = 4 }
    "us-east-1b" = { new_bits = 8, net_num = 5 }
    "us-east-1c" = { new_bits = 8, net_num = 6 }
  }
}

variable "private_subnet_config" {
  description = "Private subnet configs keyed by AZ"
  type = map(object({
    new_bits = number
    net_num  = number
  }))
  default = {
    "us-east-1a" = { new_bits = 8, net_num = 1 }
    "us-east-1b" = { new_bits = 8, net_num = 2 }
    "us-east-1c" = { new_bits = 8, net_num = 3 }
  }
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "e-commerce-project"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.37"
}

variable "node_groups" {
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  default = {
    general = {
      instance_types = ["m7i-flex.large"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
    }
  }
}
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "public subnet details"
  value       = {
    for k, v in aws_subnet.public: k => {
    id = v.id
    cidr_block = v.cidr_block
    }
  }
}

output "private_subnets" {
  description = "private subnet details"
  value       = {
    for k, v in aws_subnet.private: k => {
    id = v.id
    cidr_block = v.cidr_block
    }
  }
}

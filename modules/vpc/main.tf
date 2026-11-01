# vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

# public subnets
resource "aws_subnet" "public" {
  for_each          = var.public_subnet_config
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, each.value.new_bits, each.value.net_num)
  availability_zone = each.key 

  map_public_ip_on_launch = true

  tags = {
    Name                                        = "${var.cluster_name}-public-${each.key}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

# private subnets
resource "aws_subnet" "private" {
  for_each          = var.private_subnet_config
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, each.value.new_bits, each.value.net_num)
  availability_zone = each.key 

  map_public_ip_on_launch = false

  tags = {
    Name                                        = "${var.cluster_name}-private-${each.key}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

# internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-public"
  }
}

# public route table association with public subnets
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnet_config
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# nat gateway
resource "aws_nat_gateway" "main" {
  vpc_id            = aws_vpc.main.id
  availability_mode = "regional"

  tags = {
    Name = "${var.cluster_name}-natgw"
  }
}

# private route table
resource "aws_route_table" "private" {
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-private"
  }
}

# private route table association with private subnets
resource "aws_route_table_association" "private" {
  for_each       = var.private_subnet_config
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}

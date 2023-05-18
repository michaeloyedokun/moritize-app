# variable "vpc_cidr_block" {
# 	description = "CIDR block of the VPC"
# }

# variable "public_subnet_cidr_block" {
# 	description = "CIDR block of the public subnet"
# }

data "aws_availability_zones" "available" {
	state = "available"
}

resource "aws_vpc" "mo_k8_project_vpc" {
	cidr_block = var.vpc_cidr_block
	enable_dns_hostnames = true

	tags = {
		Name = "mo_k8_project_vpc"
	}
}

resource "aws_internet_gateway" "mo_k8_project_igw" {
	vpc_id = aws_vpc.mo_k8_project_vpc.id

	tags = {
		Name = "mo_k8_project_igw"
	}
}

# EIP for NAT
resource "aws_eip" "mo_k8_project_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.mo_k8_project_igw]
}

# NATgateway
resource "aws_nat_gateway" "mo_k8_project_nat" {
  allocation_id = aws_eip.mo_k8_project_nat_eip.id
  subnet_id     = aws_subnet.mo_k8_project_subnet_1[0].id
  depends_on    = [aws_internet_gateway.mo_k8_project_igw,
				   aws_subnet.mo_k8_project_subnet_1  
  ]
}

resource "aws_subnet" "mo_k8_project_subnet_1" {
    count = var.availability_zones_count
	vpc_id = aws_vpc.mo_k8_project_vpc.id
	cidr_block = "10.0.${count.index}.0/24"
	availability_zone = data.aws_availability_zones.available.names[count.index]

	tags = {
		Name = "mo_k8_project_subnet_1",
		Type = "public_subnet"
	}

	depends_on = [
	  aws_route_table.mo_k8_project_rt_1
	]
}

resource "aws_subnet" "mo_k8_project_subnet_2" {
    count = var.availability_zones_count
	vpc_id = aws_vpc.mo_k8_project_vpc.id
	cidr_block = "10.0.${5+count.index}.0/24"
	availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

	tags = {
		Name = "mo_k8_project_subnet_2",
		Type = "private_subnet"
	}

	depends_on = [
	  aws_nat_gateway.mo_k8_project_nat,
	  aws_route_table.mo_k8_project_rt_2
	]
}

resource "aws_route_table" "mo_k8_project_rt_1" {
	vpc_id = aws_vpc.mo_k8_project_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.mo_k8_project_igw.id
	}
}

resource "aws_route_table_association" "public" {
    count = var.availability_zones_count
	route_table_id = aws_route_table.mo_k8_project_rt_1.id
	subnet_id = aws_subnet.mo_k8_project_subnet_1[count.index].id
}

resource "aws_route_table" "mo_k8_project_rt_2" {
	vpc_id = aws_vpc.mo_k8_project_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.mo_k8_project_nat.id
	}
}

resource "aws_route_table_association" "private" {
    count = var.availability_zones_count
	route_table_id = aws_route_table.mo_k8_project_rt_2.id
	subnet_id = aws_subnet.mo_k8_project_subnet_2[count.index].id
}
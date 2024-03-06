
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/20"
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-project-VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.public_subnets[count.index]

  map_public_ip_on_launch = true 
}

resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.azs[count.index]
  cidr_block        = var.private_subnets[count.index]

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*])
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main_vpc.id
# }

# resource "aws_route_table_association" "private_routes" {
#   count          = length(aws_subnet.private_subnets[*])
#   route_table_id = aws_route_table.private.id
#   subnet_id      = aws_subnet.private_subnets[count.index].id
# }


# NAT:

# resource "aws_network_interface" "auth_instance_1" {
#   subnet_id   = var.private_subnets[0]
#   security_groups = var.security_group_ids
# }

resource "aws_eip" "auth_eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "auth_nat" {

  allocation_id = aws_eip.auth_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "auth NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id            = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.auth_nat.id
  }

  tags = {
  Name = "Route Table for NAT Gateway"
  }
}

resource "aws_route_table_association" "private_rt" {
    depends_on = [
    aws_route_table.private_rt
  ]
  subnet_id = aws_subnet.private_subnets[0].id
  route_table_id = aws_route_table.private_rt.id
}
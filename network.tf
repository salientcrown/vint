# ---------------------------------------------------------------------------------------------
#       VPC
# ---------------------------------------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}

# ----------------------------------------------------------------------------------------------
#       Internet Gateway
# ----------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}_igw"
  }
}

resource "aws_eip" "eip" {
  count      = length(var.aws_public_cidr)
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "${var.env}-eip-${count.index + 1}"
  }
}

# -----------------------------------------------------------------------------------------------
#       Subnet
# -----------------------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count = length(var.aws_public_cidr)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.aws_public_cidr[count.index]
  availability_zone       = element(slice(data.aws_availability_zones.az.names, 0, 3), (count.index))
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}_public"
  }
}


resource "aws_subnet" "private" {
  count = length(var.aws_private_cidr)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.aws_private_cidr[count.index]
  availability_zone       = element(slice(data.aws_availability_zones.az.names, 0, 3), (count.index))
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}_private"
  }
}

# -----------------------------------------------------------------------------------------------
#       Route Table
# -----------------------------------------------------------------------------------------------


resource "aws_route_table" "rtb" {
  count = length(var.aws_public_cidr)

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}_rtb"
  }
}

resource "aws_route_table_association" "a" {
  count = length(var.aws_public_cidr)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.rtb.*.id, count.index)
}

# ----------------------------------------------------------------------------------------------
#       NAT GATEWAY
# ----------------------------------------------------------------------------------------------

resource "aws_nat_gateway" "nat" {
  count = length(var.aws_private_cidr)

  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  tags = {
    Name = "${var.env}-NatGateway-${count.index + 1}"
  }
}

# ----------------------------------------------------------------------------------------------
#       Private Route
# ----------------------------------------------------------------------------------------------

resource "aws_route_table" "is_rtb" {
  count  = length(var.aws_private_cidr)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }
  tags = {
    Name = "${var.env}-isolated-${count.index + 1}"
  }
}

resource "aws_route_table_association" "b" {
  count = length(var.aws_private_cidr)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.is_rtb.*.id, count.index)
}


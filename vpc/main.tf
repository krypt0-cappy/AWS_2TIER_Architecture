###---VPC/MAIN.TF---###

data "aws_availability_zones" "available" {}

resource "random_id" "random" {
  byte_length = 4
}

resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
}

##############
# CREATE VPC #
##############

resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Main-VPC_${random_id.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#############################
# CREATE PUBLIC SUBNETS (2) #
#############################
resource "aws_subnet" "main-public-subnet" {
  count                   = var.public-subnet-count
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "Main-public-subnet-${count.index + 1}"
  }
}

##############################
# CREATE PRIVATE SUBNETS (2) #
##############################
resource "aws_subnet" "main-private-subnet" {
  count                   = var.private-subnet-count
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "Main-private-subnet-${count.index + 1}"
  }
}

#########################################
# CREATE PUBLIC ROUTE TABLE ASSOCIATION #
#########################################

resource "aws_route_table_association" "main-public-association" {
  count          = var.public-subnet-count
  subnet_id      = aws_subnet.main-public-subnet.*.id[count.index]
  route_table_id = aws_route_table.main-public-rt.id
}


##########################################
# CREATE PRIVATE ROUTE TABLE ASSOCIATION #
##########################################

resource "aws_route_table_association" "main-private_association" {
  count          = var.private-subnet-count
  subnet_id      = aws_subnet.main-private-subnet.*.id[count.index]
  route_table_id = aws_route_table.main-private-rt.id
}


#############################
# CREATE PUBLIC ROUTE TABLE #
#############################

resource "aws_route_table" "main-public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "Main-public-rt"
  }
}


############################## 
# CREATE PRIVATE ROUTE TABLE #
##############################

resource "aws_route_table" "main-private-rt" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "Main-private-rt"
  }
}


#####################
# CREATE ELASTIC IP #
#####################

resource "aws_eip" "main-eip" {}


###########################
# CREATE INTERNET GATEWAY #
###########################

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "Main-IGW"
  }
}


######################
# CREATE NAT GATEWAY #
######################

resource "aws_nat_gateway" "main-nat-gateway" {
  allocation_id = aws_eip.main-eip.id
  subnet_id     = aws_subnet.main-public-subnet[1].id
}


#################################
# CREATE A DEFAULT PUBLIC ROUTE #
#################################

resource "aws_route" "main-default-public-route" {
  route_table_id         = aws_route_table.main-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-igw.id
}


#################################
#CREATE A DEFAULT PRIVATE ROUTE #
#################################

resource "aws_route" "main-default-private-route" {
  route_table_id         = aws_route_table.main-private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main-nat-gateway.id
}


#########################################
# CREATE  A DEFAULT PRIVATE ROUTE TABLE #
#########################################

resource "aws_default_route_table" "main-default-private-route" {
  default_route_table_id = aws_vpc.main-vpc.default_route_table_id

  tags = {
    Name = "Main-private-route"
  }
}


##############################
# CREATE SECURITY GROUPS (3) #
##############################

# Security Group to allow SSH access to EC2 Instance in Public Subnet
resource "aws_security_group" "webserver-ssh-access" {
  name        = "Webserver SSH Access"
  description = "Allows SSH access to Webserver"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Security Group to allow traffic on Port 80 to the Load Balancer
resource "aws_security_group" "web_sg" {
  name        = "WebServer Security Group --- HTTP Traffic"
  description = "HTTP Traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Security Group to allow traffic from Load Balancer to ASG & SSH Access from Bastion Host (EC2 Instance in Public Subnet)
resource "aws_security_group" "app_sg" {
  name        = "Application Security Group"
  description = "Allows Traffic from Load Balancer to ASG"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver-ssh-access.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
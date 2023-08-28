###---VPC/OUTPUTS.TF---###


output "private-subnet" {
  value = aws_subnet.main-private-subnet[*].id
}

output "public-subnet" {
  value = aws_subnet.main-public-subnet[*].id
}

output "webserver-ssh-access" {
  value = aws_security_group.webserver-ssh-access.id
}

output "web_sg" {
  value = aws_security_group.web_sg.id
}

output "vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "app_sg" {
  value = aws_security_group.app_sg.id
}

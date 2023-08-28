###---VPC/VARIABLESalb.TF---###


variable "vpc_cidr" {}
variable "public-subnet-count" {
  default = 2
}
variable "private-subnet-count" {
  default = 2
}
variable "public_cidrs" {
  type = list(any)
}
variable "private_cidrs" {
  type = list(any)
}
variable "access_ip" {
  type = string
}

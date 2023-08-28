###---EC2/VARIABLES.TF---###

variable "image_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "instance_count" {
  default = 1
}
variable "key_name" {
  type = string
}
variable "public-subnet" {}
variable "private-subnet" {}
variable "public-subnet-id" {}
variable "webserver-ssh-access" {}

###---ASG/VARIABLES.TF---###

variable "image_id" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "private-subnet" {}
variable "app_sg" {}
variable "target_group_arn" {}
variable "key_name" {}

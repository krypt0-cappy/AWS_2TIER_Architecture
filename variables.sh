###---root/variables.tf---###


variable "region" {}
variable "instance_type" {}
variable "key_name" {}
variable "image_id" {}
variable "access_ip" {
  type    = string
  default = "174.57.67.44/32"
}

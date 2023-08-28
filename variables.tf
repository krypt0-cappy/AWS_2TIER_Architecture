###---root/variables.tf---###


variable "region" {
  type = string
  default = "us-east-1"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "key_name" {
  type = string
  default = "coalfire_tech_challenge_keypair"
}
variable "image_id" {
  type = string
  default = "ami-026ebd4cfe2c043b2"
}
variable "access_ip" {
  type    = string
  default = "174.57.67.44/32"
}

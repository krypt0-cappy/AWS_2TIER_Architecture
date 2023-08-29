###---root/main.tf---###


##############################################################
# Module Declarations
##############################################################



module "vpc" {
  source        = "./vpc"
  access_ip     = var.access_ip
  vpc_cidr      = local.vpc_cidr
  public_cidrs  = [for i in range(0, 255, 1) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(3, 255, 1) : cidrsubnet(local.vpc_cidr, 8, i)]
}


module "ec2" {
  source               = "./ec2"
  public-subnet        = module.vpc.public-subnet
  private-subnet       = module.vpc.private-subnet
  key_name             = var.key_name
  image_id             = var.image_id
  public-subnet-id     = module.vpc.public-subnet[1]
  webserver-ssh-access = module.vpc.webserver-ssh-access

}


module "asg" {
  source           = "./asg"
  instance_type    = var.instance_type
  image_id         = var.image_id
  private-subnet   = module.vpc.private-subnet
  target_group_arn = module.alb.target_group_arn
  app_sg           = module.vpc.app_sg
  key_name         = var.key_name
}


module "alb" {
  source        = "./alb"
  vpc_id        = module.vpc.vpc_id
  public-subnet = module.vpc.public-subnet
  web_sg        = module.vpc.web_sg
}


module "s3" {
  source = "./s3"
}
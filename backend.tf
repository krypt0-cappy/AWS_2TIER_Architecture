###---root/backend.tf---###


terraform {
  backend "s3" {
    bucket = "coalfire-tech-challenge-state-bucket" #REPLACE WITH YOUR OWN UNIQUE BUCKET NAME
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
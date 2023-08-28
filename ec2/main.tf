###---EC2/MAIN.TF---###


######################################
# CREATE EC2 INSTANCE (BASTION HOST) #
######################################

resource "aws_instance" "bastion_host" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  count                  = var.instance_count
  key_name               = var.key_name
  subnet_id              = var.public-subnet-id
  vpc_security_group_ids = [var.webserver-ssh-access]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "Main-Bastion_Host"
  }

}
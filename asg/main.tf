###---ASG/MAIN.TF---###


###################################
# CREATE ASG LAUNCH CONFIGURATION #
###################################

resource "aws_launch_configuration" "main-launch-configuration" {
    name = "ApacheWebserverLaunchConfiguration"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [var.app_sg]

    root_block_device {
      volume_size = 20
      volume_type = "gp2"
    }

     user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install httpd -y
                systemctl start httpd
                systemctl enable httpd
                EOF
}


#############################
# CREATE AUTO SCALING GROUP #
#############################

resource "aws_autoscaling_group" "main-asg" {
  name_prefix               = "AutoScalingGroupInstances"
  min_size                  = 2
  max_size                  = 6
  desired_capacity          = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = tolist(var.private-subnet)
  target_group_arns         = [var.target_group_arn]
  launch_configuration = aws_launch_configuration.main-launch-configuration.name
}
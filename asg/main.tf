###---ASG/MAIN.TF---###


##############################
# CREATE ASG LAUNCH TEMPLATE #
##############################


resource "aws_launch_template" "main-launch-template" {
  name                   = "ApacheWebserverLaunchTemplate"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.app_sg]
  user_data              = filebase64("userdata.sh")

  tags = {
    Name = "ApacheWebserverLaunchTemplate"
  }
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

  launch_template {
    id      = aws_launch_template.main-launch-template.id
    version = "$Latest"
  }
}
###---ALB/MAIN.TF---###


###################################
# CREATE APPLICATION LOADBALANCER #
###################################
resource "aws_lb" "main-loadbalancer" {
  name               = "Main-Application-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_sg]
  subnets            = tolist(var.public-subnet)
}


#######################
# CREATE ALB LISTENER #
#######################

resource "aws_lb_listener" "main-loadbalancer-listener" {
  load_balancer_arn = aws_lb.main-loadbalancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-target-group.arn
  }
}


###########################
# CREATE ALB TARGET GROUP #
###########################

resource "aws_lb_target_group" "main-target-group" {
  name        = "Main-Target-Group"
  port        = var.listener_port
  protocol    = var.listener_protocol
  target_type = "instance"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  health_check {
    enabled             = true
    interval            = var.lb_interval
    path                = "/"
    timeout             = var.lb_timeout
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
  }
}
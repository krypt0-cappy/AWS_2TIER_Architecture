###---ALB/OUTPUTS.TF---###


output "target_group_arn" {
  value = aws_lb_target_group.main-target-group.arn
}

output "loadbalancer" {
  value = aws_lb.main-loadbalancer.id
}

output "loadbalancer_dns" {
  value = aws_lb.main-loadbalancer.dns_name
}
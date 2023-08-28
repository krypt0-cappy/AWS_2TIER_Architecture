#--root/outputs.tf

output "lb_dns" {
  value = module.alb.loadbalancer_dns
}
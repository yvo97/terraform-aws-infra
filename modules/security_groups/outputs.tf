output "lb_sg_id" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.lb.id
}

output "ec2_sg_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}
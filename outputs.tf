output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "load_balancer_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "dev_instance_private_ip" {
  description = "Private IP of the dev instance"
  value       = module.ec2_dev.private_ip
}

output "prod_instance_private_ip" {
  description = "Private IP of the prod instance"
  value       = module.ec2_prod.private_ip
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}
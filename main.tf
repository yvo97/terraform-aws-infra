module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
}

module "security_groups" {
  source      = "./modules/security_groups"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "ec2_dev" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_id  = module.security_groups.ec2_sg_id
  subnet_id          = module.vpc.private_subnet_ids[0]
  user_data          = file("${path.module}/user_data.sh")
  environment        = var.environment
  instance_name      = "dev"
}

module "ec2_prod" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  security_group_id  = module.security_groups.ec2_sg_id
  subnet_id          = module.vpc.private_subnet_ids[1]
  user_data          = file("${path.module}/user_data.sh")
  environment        = var.environment
  instance_name      = "prod"
}

# Load Balancer
resource "aws_lb" "main" {
  name               = "${var.environment}-main-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security_groups.lb_sg_id]
  subnets            = module.vpc.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.environment}-main-lb"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "${var.environment}-main-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.environment}-main-tg"
  }
}

resource "aws_lb_target_group_attachment" "dev" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = module.ec2_dev.instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "prod" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = module.ec2_prod.instance_id
  port             = 80
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
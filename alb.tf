#create target group
resource "aws_lb_target_group" "alb-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_terraform.id
}

# attachment nginx-01 to alb-target-group
resource "aws_lb_target_group_attachment" "alb-target-group-attachment1" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = aws_instance.nginx-01.id
  port             = 80
}

## attachment nginx-02 to alb-target-group
resource "aws_lb_target_group_attachment" "alb-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = aws_instance.nginx-02.id
  port             = 80
}

#Create ALB
resource "aws_lb" "alb-terraform" {
  name     = "alb-terraform-01"
  internal = false

  security_groups = [
    aws_security_group.sg-alb-terraform.id,
  ]

  subnets = [
    aws_subnet.public-az-a.id,
    aws_subnet.public-az-b.id
  ]

  tags = {
    Name = "alb-terraform-01"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

#add HTTP - 80  listener to ALB
resource "aws_lb_listener" "alb-terraform-listner" {
  load_balancer_arn = aws_lb.alb-terraform.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

#create a specific security group to ALB
resource "aws_security_group" "sg-alb-terraform" {
  name   = "sg_alb_terraform"
  vpc_id = aws_vpc.vpc_terraform.id
}

#add rules to ALB
resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg-alb-terraform.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg-alb-terraform.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
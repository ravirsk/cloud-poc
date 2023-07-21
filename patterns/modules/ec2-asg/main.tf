resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance-SG"
  description = "Allow http inbound traffic"
  vpc_id      = var.aws_vpc_id

  
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name = "terraform-example-instance-SG"
  }
}

resource "aws_launch_configuration" "TerraASGLaunchConfexample" {
  image_id        = "ami-022e1a32d3f742bd8"
  instance_type   = var.aws_ec2_instance_type

  key_name       = "OOAKeyLinux"
  security_groups = [aws_security_group.instance.id]

  user_data = templatefile( "user-data.sh", {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  })

# Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
  
}

resource "aws_autoscaling_group" "TerraASG" {
  launch_configuration = aws_launch_configuration.TerraASGLaunchConfexample.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }
}

resource "aws_lb" "examplelb" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  internal 			 = "true"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb-SG.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.examplelb.arn
  port              = local.http_port
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb-SG" {
  name = "${var.cluster_name}-alb-SG"
   vpc_id   = var.aws_vpc_id

  # Allow inbound HTTP requests
  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  # Allow all outbound requests
  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}







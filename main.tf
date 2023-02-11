
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "tf-key-pair" {
  key_name = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.Private_key_filename
}

resource "aws_instance" "web-server1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.EC2_Instance_type
  key_name = aws_key_pair.tf-key-pair.key_name
  security_groups    = [aws_security_group.lb_sg.id]
  subnet_id          = aws_subnet.public_subnet1.id

  tags = {
    Name = var.Server1_name
  }
}

resource "aws_instance" "web-server2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.EC2_Instance_type
  key_name = aws_key_pair.tf-key-pair.key_name
  security_groups    = [aws_security_group.lb_sg.id]
  subnet_id          = aws_subnet.public_subnet1.id

  tags = {
    Name = var.Server2_name
  }
}

resource "aws_instance" "web-server3" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.EC2_Instance_type
  key_name = aws_key_pair.tf-key-pair.key_name
  security_groups    = [aws_security_group.lb_sg.id]
  subnet_id          = aws_subnet.public_subnet1.id

  tags = {
    Name = var.Server3_name
  }
}

resource "local_file" "altschool-file" {
  filename = var.EC2_IP_Address
  content = <<-EOT
    [webserver1]
    ${aws_instance.web-server1.public_ip}

    [webserver2]
    ${aws_instance.web-server2.public_ip}

    [webserver3]
    ${aws_instance.web-server3.public_ip}
    
  EOT
}

resource "aws_lb" "ec2_alb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.lb_sg.id]
  idle_timeout       = 60
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = var.lb_target_group_name
  port        = 8000
  protocol    = "HTTP"
  target_type = var.lb_target_group_type
  vpc_id      = aws_vpc.main.id

  health_check {
    enabled = true
    path = "/"
    port = "8000"
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 2
    interval = 90
    timeout = 20
    matcher = "200"
  }

  depends_on = [aws_lb.ec2_alb]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ec2_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn

  }
}

resource "aws_lb_target_group_attachment" "one" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web-server1.private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "two" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web-server2.private_ip
  port             = 80
}

resource "aws_lb_target_group_attachment" "three" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web-server3.private_ip
  port             = 80
}

resource "aws_route53_zone" "primary" {
  name = var.aws_route53_zone_name
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.aws_route53_record_www_name
  type    = var.aws_route53_record_type

  alias {
    name                   = aws_lb.ec2_alb.dns_name
    zone_id                = aws_lb.ec2_alb.zone_id
    evaluate_target_health = true
  }

}

resource "aws_route53_record" "terraform-test" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.aws_route53_record_terraform_name
  type    = var.aws_route53_record_type

  alias {
    name                   = aws_lb.ec2_alb.dns_name
    zone_id                = aws_lb.ec2_alb.zone_id
    evaluate_target_health = true
  }

}

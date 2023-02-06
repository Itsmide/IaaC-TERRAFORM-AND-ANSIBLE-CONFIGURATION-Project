variable "key_pair_name" {
  type    = string
  default = "tf-key-pair"
}

variable "Private_key_filename" {
  type    = string
  default = "tf-key-pair.pem"
}

variable "EC2_Instance_type" {
  type    = string
  default = "t2.micro"
}

variable "EC2_IP_Address" {
  type    = string
  default = "host-inventory"
}

variable "lb_name" {
  type    = string
  default = "ec2-alb"
}

variable "lb_type" {
  type    = string
  default = "application"
}

variable "lb_target_group_name" {
  type    = string
  default = "alb-tg"
}

variable "lb_target_group_type" {
  type    = string
  default = "ip"
}

variable "aws_route53_zone_name" {
  type    = string
  default = "itsmidealtschoolexamproject.live"
}

variable "aws_route53_record_www_name" {
  type    = string
  default = "www.itsmidealtschoolexamproject.live"
}

variable "aws_route53_record_terraform_name" {
  type    = string
  default = "terraform-test.itsmidealtschoolexamproject.live"
}

variable "aws_route53_record_type" {
  type    = string
  default = "A"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "Server1_name" {
  type    = string
  default = "Server-1"
}

variable "Server2_name" {
  type    = string
  default = "Server-2"
}

variable "Server3_name" {
  type    = string
  default = "Server-3"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "aws_security_group_name" {
  type    = string
  default = "ec2-lb-sg"
}

variable "ec2_lb_sg_tags-name" {
  type    = string
  default = "terraform-ec2-lb-sg"
}





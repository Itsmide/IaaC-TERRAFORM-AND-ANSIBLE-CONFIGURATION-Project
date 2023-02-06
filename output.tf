output "Server_ip_1" {     
  value = "${aws_instance.web-server1.public_ip}"
}

output "Server_ip_2" {     
  value = "${aws_instance.web-server2.public_ip}"
}

output "Server_ip_3" {
  value = "${aws_instance.web-server3.public_ip}"
}

output "Load_balancer_ip" {
  value = "${aws_lb.ec2_alb.dns_name}"
}
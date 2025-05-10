output "alb_dns_name" {
  value = aws_lb.myalb.dns_name
}

output "aws_instance_public_ip" {
  value = aws_instance.webserver1.public_ip  
}

output "aws_instance_public_ip2" {
  value = aws_instance.webserver2.public_ip   
}
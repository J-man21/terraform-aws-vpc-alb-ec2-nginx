output "public_dns_nginx-01" {
  description = "List of public DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.nginx-01.*.public_dns
}

output "public_dns_nginx-02" {
  description = "List of public DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = aws_instance.nginx-02.*.public_dns
}

output "aws_lb_dns" {
  description = "List of public DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = concat(aws_lb.alb-terraform.*.dns_name, [""])[0]
}

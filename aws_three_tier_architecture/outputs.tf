# Getting the DNS of load balancer
#we need the dns to be able to access the application
output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = "${aws_lb.external-alb.dns_name}"
}
#while working with modules, always go to Outputs section to get the attibutes
#If you do intend to export this data, annotate the output value as sensitive by adding the following
output "private_key_pem" {
  sensitive = true
  description = "The private key for ssh access"  
  value = module.key_pair.private_key_pem
}

#while working with modules, always go to Outputs section to get the attibutes
output "key_pair_name" {
  description = "The private key name"  
  value = module.key_pair.key_pair_name
}
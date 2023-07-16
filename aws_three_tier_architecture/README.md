Our Terraform configuration module is defined one Application Load Balancer (ALB) with the resource block:

resource "aws_lb" "external-alb" {
  name               = "External-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demosg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}


This resource block creates a single Application Load Balancer named "External-LB" with the specified attributes.

Additionally, the module is defining a target group attachment for two EC2 instances:

resource "aws_lb_target_group_attachment" "attachment-01" {
  count            = 1
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id        = aws_instance.demoinstance[count.index].id
  port             = 80
  depends_on       = [aws_instance.demoinstance]
}

resource "aws_lb_target_group_attachment" "attachment-02" {
  count            = 1
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id        = aws_instance.demoinstance1[count.index].id
  port             = 80
  depends_on       = [aws_instance.demoinstance1]
}

I had a blocker creating the database due to version deprecation. i had to access the database console on aws to write down the parameters and version i need.



Since these attachments have a count of 1, they will each create a single target group attachment. The count attribute here is used to associate the EC2 instances with the target group. When the count is set to 1, it means the attachment will be created once for each instance.

So, in total, the module will create 1 vpc, 6 subnets (4 private subnets, 2 public subnet), 2 AZs, one Application Load Balancer and two target group attachments, one for each EC2 instance specified in the configuration.

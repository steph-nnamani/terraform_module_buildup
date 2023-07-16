# Creating External LoadBalancer
#The above load balancer is of type external
#Load balancer type is set to application
#The aws_lb_target_group_attachment resource will attach our instances to the Target Group.
#The load balancer will listen requests on port 80

resource "aws_lb" "external-alb" {
  name               = "External-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.demosg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}
resource "aws_lb_target_group" "target-elb" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demovpc.id
}
resource "aws_lb_target_group_attachment" "attachment-01" {
  count            = 1  # Added count here to create multiple attachments  
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id        = aws_instance.demoinstance[count.index].id  # Accessing attribute with [count.index]
  port             = 80
depends_on = [
  aws_instance.demoinstance,
]
}
resource "aws_lb_target_group_attachment" "attachment-02" {
  count            = 1  # Added count here to create multiple attachments
  target_group_arn = aws_lb_target_group.target-elb.arn
  target_id        = aws_instance.demoinstance1[count.index].id  # Accessing attribute with [count.index]
  port             = 80
depends_on = [
  aws_instance.demoinstance1
]
}
resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.external-alb.arn
  port              = "80"
  protocol          = "HTTP"
default_action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.target-elb.arn
}
}